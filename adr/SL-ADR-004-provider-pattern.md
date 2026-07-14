---
id: sl-adr-004
title: "Provider Pattern para Integrações Externas"
version: "1.0.0"
status: "approved"
owner: "Chief Architect"
depends_on: ["dpes-adr-007", "dpes-contrats"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# SL-ADR-004: Provider Pattern para Integrações Externas

## Contexto

Studio Letícia depende de serviços externos: Mercado Pago (pagamentos), FCM (push), OpenAI (IA), Resend (e-mail). O domínio não pode estar acoplado a provedores específicos — trocar de provedor não deve impactar regras de negócio.

## Decisão

Toda integração externa segue o **Provider Pattern** definido no CONTRACTS layer: interface abstrata no domínio, implementação concreta na infraestrutura.

## Estrutura

```
contracts/                    (interfaces abstratas — no domínio)
  payment_provider.dart
  notification_provider.dart
  ai_provider.dart

platform/                     (implementações — na infraestrutura)
  payments/
    mercado_pago_provider.dart
  notifications/
    fcm_push_provider.dart
    email_provider.dart
    whatsapp_provider.dart
  ai/
    openai_provider.dart
```

## Consequências

- Trocar Mercado Pago por Stripe = nova implementação, zero mudança no domínio
- Testes com mocks sem chamar APIs externas
- Cada implementação pode ter estratégia própria de retry/circuit-breaker
- Camada extra de abstração (custo inicial baixo, benefício alto)

## Exemplo

```dart
// Domínio depende apenas da abstração
class CommissionService {
  final PaymentProvider _payment;

  CommissionService(this._payment); // <- qualquer implementação serve

  Future<void> process(Appointment appointment) async {
    final result = await _payment.process(PaymentRequest(
      amount: appointment.totalAmount,
      method: PaymentMethod.pix,
    ));
  }
}

// Teste usa mock
final mockPayment = MockPaymentProvider();
final service = CommissionService(mockPayment);
```

## Alternativas Consideradas

| Alternativa | Motivo para rejeitar |
|---|---|
| Chamar SDK direto | Acoplamento, troca de provedor quebra o domínio |
| Camada de adaptação por módulo | Duplicação de código, inconsistência entre módulos |
| Sem abstração (fazer direto) | Impossível testar sem chamar API real |

## Status

✅ Aprovado
