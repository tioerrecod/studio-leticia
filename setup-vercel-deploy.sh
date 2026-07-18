#!/bin/bash
# ───────────────────────────────────────────────────────
# Studio Letícia 3.0 — Vercel Deploy Setup
# Execute este script para configurar o deploy automático
# ───────────────────────────────────────────────────────

echo "=== Studio Letícia — Configuração de Deploy Vercel ==="
echo ""

# ── 1. VERCEL_TOKEN ────────────────────────────────────
echo "PASSO 1: Criar Token de Acesso Vercel"
echo "  Acesse: https://vercel.com/account/tokens"
echo "  Crie um token com nome 'studio-leticia-deploy'"
echo "  Copie o token gerado"
echo ""

# ── 2. GitHub Secrets ──────────────────────────────────
echo "PASSO 2: Configurar GitHub Secrets"
echo "  Repositório: Settings > Secrets and variables > Actions"
echo ""
echo "  Adicione os seguintes Repository secrets:"
echo ""
echo "  ┌────────────────────────────────────┬──────────────────────────────────────────────┐"
echo "  │ NOME                               │ VALOR                                        │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ VERCEL_TOKEN                       │ Token criado no Passo 1                      │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ VERCEL_ORG_ID                      │ team_1cU25S1fd5qCaPOEaDZBF1tg                │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ VERCEL_CUSTOMER_PROJECT_ID         │ prj_m1s8lYaFbDmAa9nnzR1N5JGp4oNw              │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ VERCEL_ADMIN_PROJECT_ID            │ prj_USwUEtnAeeOLX1TLeWVRppMxqSNg              │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ SUPABASE_URL                       │ https://iwtqgxqpblmvahzsnnge.supabase.co      │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ SUPABASE_ANON_KEY                  │ eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...      │"
echo "  ├────────────────────────────────────┼──────────────────────────────────────────────┤"
echo "  │ SUPABASE_PROJECT_REF               │ iwtqgxqpblmvahzsnnge                          │"
echo "  └────────────────────────────────────┴──────────────────────────────────────────────┘"
echo ""

# ── 3. URLs deploy ────────────────────────────────────
echo "PASSO 3: URLs de produção"
echo "  Customer App: https://studio-leticia-customer.vercel.app"
echo "  Admin App:    https://studio-leticia-admin.vercel.app"
echo ""

echo "=== Após configurar os secrets, faça um push para main ==="
echo "O deploy automático será acionado!"
