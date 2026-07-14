---
id: sl-adr-003
title: "Multi-tenancy Desde o Início"
version: "1.0.0"
status: "approved"
owner: "Chief Architect"
depends_on: ["dpes-adr-005"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# SL-ADR-003: Multi-tenancy Desde o Início

## Contexto

PRD define evolução de "Studio Letícia" (primeiro inquilino) para "Beauty Platform" (múltiplos salões). Refatorar para multi-tenancy depois do MVP custa caro: migração de dados, reescrita de queries, recriação de policies.

## Decisão

Toda tabela de negócio terá `tenant_id UUID NOT NULL` desde o primeiro migration. Isolamento via RLS. tenant_id no JWT (app_metadata).

## Consequências

- Zero retrabalho quando segundo salão entrar
- Isolamento por RLS (segurança em nível de banco)
- Performance aceitável com índice composto em (tenant_id, id)
- Overhead mínimo em queries: WHERE tenant_id = current_tenant
- Backup restaura todos os tenants (schema separado por tenant se necessário no futuro)

## Implementação

```sql
-- Helper function (no JWT)
CREATE OR REPLACE FUNCTION get_user_tenant_id()
RETURNS UUID AS $$
  SELECT (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'tenant_id')::uuid;
$$ LANGUAGE sql STABLE;

-- Trigger auto-fill
CREATE OR REPLACE FUNCTION set_tenant_id()
RETURNS TRIGGER AS $$
BEGIN
  NEW.tenant_id := get_user_tenant_id();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Policy padrão
CREATE POLICY tenant_isolation ON appointments
  FOR ALL USING (tenant_id = get_user_tenant_id());
```

## Alternativas Consideradas

| Alternativa | Motivo para rejeitar |
|---|---|
| Banco por tenant | Complexidade operacional, backup, migrations duplicadas |
| Schema por tenant | PostgreSQL schema search_path complexo, migrations replicadas |
| Adicionar depois | Custo altíssimo de refatoração, risco de dados vazados |

## Status

✅ Aprovado
