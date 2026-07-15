import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

class FinancialScreen extends ConsumerWidget {
  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financialSummaryProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final cashRegisterAsync = ref.watch(openCashRegisterProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Financeiro',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: SLColors.champagne),
            onPressed: () {
              // TODO: Navigate to reports
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SLSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Card
            summaryAsync.when(
              loading: () => const _LoadingCard(),
              error: (e, _) => _ErrorCard(message: 'Erro ao carregar resumo'),
              data: (summary) => _RevenueCard(
                todayRevenue: summary.todayRevenue,
                pixToday: summary.pixToday,
                cardToday: summary.cardToday,
                cashToday: summary.cashToday,
              ),
            ),
            const SizedBox(height: SLSpacing.lg),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: cashRegisterAsync.when(
                    loading: () => const _LoadingQuickAction(),
                    error: (_, __) => _QuickActionCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Abrir Caixa',
                      onTap: () => _openCashRegister(context, ref),
                    ),
                    data: (cashRegister) {
                      if (cashRegister == null || cashRegister.isClosed) {
                        return _QuickActionCard(
                          icon: Icons.account_balance_wallet,
                          label: 'Abrir Caixa',
                          onTap: () => _openCashRegister(context, ref),
                        );
                      }
                      return _QuickActionCard(
                        icon: Icons.lock_outline,
                        label: 'Fechar Caixa',
                        onTap: () => _closeCashRegister(context, ref, cashRegister.id),
                      );
                    },
                  ),
                ),
                const SizedBox(width: SLSpacing.md),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.money_off,
                    label: 'Registrar Despesa',
                    onTap: () {
                      // TODO: Navigate to expense form
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.lg),

            // Commissions Summary
            summaryAsync.when(
              loading: () => const _LoadingCard(),
              error: (e, _) => const SizedBox(),
              data: (summary) => _CommissionsCard(
                pendingCommissions: summary.pendingCommissions,
              ),
            ),
            const SizedBox(height: SLSpacing.lg),

            // Recent Transactions
            Text(
              'Últimas Transações',
              style: SLTypography.h3.copyWith(
                color: SLColors.carbon,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: SLSpacing.md),

            transactionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: SLColors.champagne),
              ),
              error: (e, _) => Center(
                child: Text('Erro ao carregar transações', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(SLSpacing.xl),
                      child: Text(
                        'Nenhuma transação hoje',
                        style: SLTypography.body.copyWith(color: SLColors.textDisabled),
                      ),
                    ),
                  );
                }

                return Column(
                  children: transactions.take(5).map((t) => _TransactionCard(transaction: t)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openCashRegister(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _OpenCashRegisterDialog(
        onConfirm: (amount) async {
          final repository = ref.read(financialRepositoryProvider);
          await repository.openCashRegister(amount);
          ref.invalidate(openCashRegisterProvider);
          ref.invalidate(financialSummaryProvider);
        },
      ),
    );
  }

  void _closeCashRegister(BuildContext context, WidgetRef ref, String registerId) {
    showDialog(
      context: context,
      builder: (context) => _CloseCashRegisterDialog(
        onConfirm: (amount, notes) async {
          final repository = ref.read(financialRepositoryProvider);
          await repository.closeCashRegister(
            id: registerId,
            actualBalance: amount,
            notes: notes,
          );
          ref.invalidate(openCashRegisterProvider);
          ref.invalidate(financialSummaryProvider);
          ref.invalidate(transactionsProvider);
        },
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final double todayRevenue;
  final double pixToday;
  final double cardToday;
  final double cashToday;

  const _RevenueCard({
    required this.todayRevenue,
    required this.pixToday,
    required this.cardToday,
    required this.cashToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SLSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SLColors.champagne, SLColors.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: SLRadius.modal,
        boxShadow: [
          BoxShadow(
            color: SLColors.champagne.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faturamento Hoje',
          style: SLTypography.caption.copyWith(
            color: SLColors.background.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: SLSpacing.xs),
        Text(
          'R\$ ${todayRevenue.toStringAsFixed(2)}',
          style: SLTypography.display.copyWith(
            color: SLColors.background,
            fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          Row(
            children: [
              _PaymentMethod(
                icon: Icons.qr_code,
                label: 'PIX',
                amount: pixToday,
              ),
              const SizedBox(width: SLSpacing.md),
              _PaymentMethod(
                icon: Icons.credit_card,
                label: 'Cartão',
                amount: cardToday,
              ),
              const SizedBox(width: SLSpacing.md),
              _PaymentMethod(
                icon: Icons.money,
                label: 'Dinheiro',
                amount: cashToday,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethod extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;

  const _PaymentMethod({
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(SLSpacing.sm),
        decoration: BoxDecoration(
          color: SLColors.background.withValues(alpha: 0.1),
          borderRadius: SLRadius.input,
        ),
        child: Column(
          children: [
            Icon(icon, color: SLColors.background, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: SLTypography.overline.copyWith(
                color: SLColors.background.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
            Text(
              'R\$ ${amount.toStringAsFixed(0)}',
              style: SLTypography.body.copyWith(
                color: SLColors.background,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SLSpacing.md),
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.card,
          border: Border.all(color: SLColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: SLColors.champagne, size: 24),
            const SizedBox(height: SLSpacing.xs),
            Text(
              label,
              style: SLTypography.caption.copyWith(
                color: SLColors.carbon,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommissionsCard extends StatelessWidget {
  final double pendingCommissions;

  const _CommissionsCard({required this.pendingCommissions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SLColors.warning.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people, color: SLColors.warning, size: 20),
          ),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comissões Pendentes',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
                Text(
                  'R\$ ${pendingCommissions.toStringAsFixed(2)}',
                  style: SLTypography.h3.copyWith(
                    color: SLColors.carbon,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: SLColors.textDisabled, size: 20),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final FinancialTransaction transaction;

  const _TransactionCard({required transaction}) : transaction = transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SLSpacing.sm),
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getTypeColor(transaction.type).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTypeIcon(transaction.type),
              color: _getTypeColor(transaction.type),
              size: 18,
            ),
          ),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? transaction.type,
                  style: SLTypography.body.copyWith(
                    color: SLColors.carbon,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.paymentMethod ?? '-'} · ${_formatTime(transaction.createdAt)}',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.isExpense || transaction.isCommission ? '-' : '+'}R\$ ${transaction.amount.toStringAsFixed(2)}',
            style: SLTypography.body.copyWith(
              color: transaction.isExpense || transaction.isCommission
                  ? SLColors.error
                  : SLColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'revenue':
        return SLColors.success;
      case 'expense':
        return SLColors.error;
      case 'commission':
        return SLColors.warning;
      default:
        return SLColors.textSecondary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'revenue':
        return Icons.arrow_downward;
      case 'expense':
        return Icons.arrow_upward;
      case 'commission':
        return Icons.people;
      default:
        return Icons.receipt;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
      ),
      child: const Center(
        child: CircularProgressIndicator(color: SLColors.champagne),
      ),
    );
  }
}

class _LoadingQuickAction extends StatelessWidget {
  const _LoadingQuickAction();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
      ),
      child: const Center(
        child: CircularProgressIndicator(color: SLColors.champagne),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SLSpacing.lg),
      decoration: BoxDecoration(
        color: SLColors.error.withValues(alpha: 0.1),
        borderRadius: SLRadius.card,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: SLColors.error),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Text(
              message,
              style: SLTypography.body.copyWith(color: SLColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dialogs ──────────────────────────────────────────
class _OpenCashRegisterDialog extends StatefulWidget {
  final Function(double) onConfirm;

  const _OpenCashRegisterDialog({required this.onConfirm});

  @override
  State<_OpenCashRegisterDialog> createState() => _OpenCashRegisterDialogState();
}

class _OpenCashRegisterDialogState extends State<_OpenCashRegisterDialog> {
  final _controller = TextEditingController(text: '0.00');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SLColors.surface,
      title: Text(
        'Abrir Caixa',
        style: SLTypography.h3.copyWith(color: SLColors.carbon),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Saldo inicial:',
            style: SLTypography.body.copyWith(color: SLColors.textSecondary),
          ),
          const SizedBox(height: SLSpacing.md),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: 'R\$ ',
              border: OutlineInputBorder(
                borderRadius: SLRadius.card,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: SLRadius.card,
                borderSide: const BorderSide(color: SLColors.champagne),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text) ?? 0;
            widget.onConfirm(amount);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SLColors.champagne,
            foregroundColor: SLColors.background,
          ),
          child: const Text('Abrir'),
        ),
      ],
    );
  }
}

class _CloseCashRegisterDialog extends StatefulWidget {
  final Function(double, String?) onConfirm;

  const _CloseCashRegisterDialog({required this.onConfirm});

  @override
  State<_CloseCashRegisterDialog> createState() => _CloseCashRegisterDialogState();
}

class _CloseCashRegisterDialogState extends State<_CloseCashRegisterDialog> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SLColors.surface,
      title: Text(
        'Fechar Caixa',
        style: SLTypography.h3.copyWith(color: SLColors.carbon),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Valor em caixa (R\$)',
              border: OutlineInputBorder(
                borderRadius: SLRadius.card,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: SLRadius.card,
                borderSide: const BorderSide(color: SLColors.champagne),
              ),
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Observações',
              border: OutlineInputBorder(
                borderRadius: SLRadius.card,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: SLRadius.card,
                borderSide: const BorderSide(color: SLColors.champagne),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text) ?? 0;
            final notes = _notesController.text.isEmpty ? null : _notesController.text;
            widget.onConfirm(amount, notes);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SLColors.champagne,
            foregroundColor: SLColors.background,
          ),
          child: const Text('Fechar Caixa'),
        ),
      ],
    );
  }
}