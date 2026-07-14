---
id: sl-adr-001
title: "Flutter como Plataforma Principal"
version: "1.0.0"
status: "approved"
owner: "Chief Architect"
depends_on: ["dpes-adr-002"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# SL-ADR-001: Flutter como Plataforma Principal

## Contexto

Studio Letícia precisa atender três personas (dona, profissional, cliente final) em dispositivos móveis (Android + iOS) e web (admin). O produto depende de experiência visual premium com animações fluidas para se diferenciar no mercado de salões de beleza.

## Decisão

**Flutter** será a plataforma única para todos os clients:
- Customer App (Android + iOS)
- Professional App (Android + iOS)
- Admin Web (Flutter Web)

## Consequências

- Código compartilhado entre os 3 clients (~80% dos packages)
- Animações de 60fps nativas via Skia engine
- Hot reload para desenvolvimento rápido
- Web não é SEO-friendly → página pública do salão será HTML estático separado
- Bundle size ~15-20mb (vs ~5-8mb nativo)

## Alternativas Consideradas

| Alternativa | Motivo para rejeitar |
|---|---|
| React Native | Performance inferior de animações, experiência visual menos premium |
| Kotlin + Swift (nativo) | Custo 2x para manter Android + iOS + Web |
| PWA apenas | Performance, acesso a recursos nativos, credibilidade |

## Status

✅ Aprovado
