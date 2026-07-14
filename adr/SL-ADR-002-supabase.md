---
id: sl-adr-002
title: "Supabase como Backend Foundation"
version: "1.0.0"
status: "approved"
owner: "Chief Architect"
depends_on: ["dpes-adr-003", "dpes-adr-004"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# SL-ADR-002: Supabase como Backend Foundation

## Contexto

Studio Letícia precisa de autenticação, banco de dados relacional, armazenamento de arquivos, realtime, e funções serverless. O time é pequeno (1-2 engenheiros) e velocidade de desenvolvimento é prioridade.

## Decisão

**Supabase** como plataforma de backend única, substituindo:
- PostgreSQL gerenciado
- Serviço de autenticação
- Storage de arquivos
- Realtime/subscriptions
- Edge Functions (Deno)

## Consequências

- PostgreSQL real com RLS, migrations, PITR
- Auth built-in (Google, Email, Magic Link)
- Realtime para notificações e atualizações ao vivo
- Storage para fotos do salão
- Edge Functions para lógica serverless
- Vendor lock-in mitigado: SQL padrão, Provider Pattern para integrações
- Cold start de Edge Functions (~500ms)

## Alternativas Consideradas

| Alternativa | Motivo para rejeitar |
|---|---|
| Firebase + Cloud Functions | Firestore não é relacional, sem RLS nativo, vendor lock-in maior |
| Node + Express + PostgreSQL gerenciado | Mais operação, sem auth built-in, sem realtime |
| Rails + PostgreSQL | Stack diferente do ecossistema Flutter/Dart |

## Status

✅ Aprovado
