import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

const _expenseCategories = [
  'Aluguel',
  'Água',
  'Luz',
  'Telefone/Internet',
  'Produtos',
  'Equipamentos',
  'Manutenção',
  'Marketing',
  'Salários',
  'Pró-Labore',
  'Impostos',
  'Outros',
];

const _paymentMethods = [
  'pix',
  'credit_card',
  'debit_card',
  'cash',
];

String _paymentMethodLabel(String method) {
  switch (method) {
    case 'pix': return 'PIX';
    case 'credit_card': return 'Cartão de Crédito';
    case 'debit_card': return 'Cartão de Débito';
    case 'cash': return 'Dinheiro';
    default: return method;
  }
}

class FinancialScreen extends ConsumerWidget {
  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financialSummaryProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final cashRegisterAsync = ref.watch(openCashRegisterProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SLSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summaryAsync.when(
                loading: () => const _LoadingCard(),
                error: (e, _) =>
                    _ErrorCard(message: 'Erro ao carregar resumo'),
                data: (summary) => _RevenueCard(
                  todayRevenue: summary.todayRevenue,
                  pixToday: summary.pixToday,
                  cardToday: summary.cardToday,
                  cashToday: summary.cashToday,
                ),
              ),
              const SizedBox(height: SLSpacing.lg),
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
                          onTap: () =>
                              _closeCashRegister(context, ref, cashRegister.id),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: SLSpacing.md),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.money_off,
                      label: 'Registrar Despesa',
                      onTap: () => _showExpenseForm(context, ref),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.lg),
              summaryAsync.when(
                loading: () => const _LoadingCard(),
                error: (e, _) => const SizedBox(),
                data: (summary) => _CommissionsCard(
                  pendingCommissions: summary.pendingCommissions,
                ),
              ),
              const SizedBox(height: SLSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Últimas Transações',
                    style: SLTypography.h3.copyWith(
                      color: SLColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.invalidate(transactionsProvider),
                    child: const Icon(Icons.refresh,
                        size: 20, color: SLColors.accentGold),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.md),
              transactionsAsync.when(
                loading: () => const Center(
                  child:
                      CircularProgressIndicator(color: SLColors.accentGold),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Erro ao carregar transações',
                    style: SLTypography.body.copyWith(
                        color: SLColors.textSecondary),
                  ),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(SLSpacing.xl),
                        child: Text(
                          'Nenhuma transação hoje',
                          style: SLTypography.body.copyWith(
                              color: SLColors.textDisabled),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: transactions
                        .take(5)
                        .map((t) => _TransactionCard(transaction: t))
                        .toList(),
                  );
                },
              ),
            ],
          ),
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

  void _closeCashRegister(
      BuildContext context, WidgetRef ref, String registerId) {
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

  void _showExpenseForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SLColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(28)),
      ),
      builder: (ctx) => _ExpenseFormSheet(
        onSave: (description, category, amount, paymentMethod, date, notes) async {
          final repository = ref.read(financialRepositoryProvider);
          final transaction = FinancialTransaction(
            id: '',
            type: 'expense',
            category: category,
            amount: amount,
            description: description,
            paymentMethod: paymentMethod,
            status: 'completed',
            createdAt: date,
          );
          await repository.createTransaction(transaction);
          ref.invalidate(transactionsProvider);
          ref.invalidate(financialSummaryProvider);
          ref.invalidate(todayExpensesProvider);
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// _RevenueCard
// ══════════════════════════════════════════════════════════════
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
          colors: [SLColors.accentGold, SLColors.accentGoldLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: SLRadius.modal,
        boxShadow: [
          BoxShadow(
            color: SLColors.accentGold.withValues(alpha: 0.3),
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
              color: SLColors.bgPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: SLSpacing.xs),
          Text(
            'R\$ ${todayRevenue.toStringAsFixed(2)}',
            style: SLTypography.display.copyWith(
              color: SLColors.bgPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          Row(
            children: [
              Expanded(
                child: _PaymentMethod(
                  icon: Icons.qr_code,
                  label: 'PIX',
                  amount: pixToday,
                ),
              ),
              const SizedBox(width: SLSpacing.sm),
              Expanded(
                child: _PaymentMethod(
                  icon: Icons.credit_card,
                  label: 'Cartão',
                  amount: cardToday,
                ),
              ),
              const SizedBox(width: SLSpacing.sm),
              Expanded(
                child: _PaymentMethod(
                  icon: Icons.money,
                  label: 'Dinheiro',
                  amount: cashToday,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// _PaymentMethod — sem quebra de palavra
// ══════════════════════════════════════════════════════════════
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.xs,
        vertical: SLSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: SLColors.bgPrimary.withValues(alpha: 0.1),
        borderRadius: SLRadius.input,
      ),
      child: Column(
        children: [
          Icon(icon, color: SLColors.bgPrimary, size: 18),
          const SizedBox(height: SLSpacing.space1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: SLTypography.badge.copyWith(
                color: SLColors.bgPrimary.withValues(alpha: 0.6),
                letterSpacing: 0.3,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'R\$ ${amount.toStringAsFixed(0)}',
              style: SLTypography.caption.copyWith(
                color: SLColors.bgPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// _QuickActionCard
// ══════════════════════════════════════════════════════════════
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
      child: SLCard(
        variant: SLCardVariant.outlined,
        padding: const EdgeInsets.symmetric(vertical: SLSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: SLColors.accentGold, size: 24),
            const SizedBox(height: SLSpacing.xs),
            Text(
              label,
              style: SLTypography.caption.copyWith(
                color: SLColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// _CommissionsCard
// ══════════════════════════════════════════════════════════════
class _CommissionsCard extends StatelessWidget {
  final double pendingCommissions;

  const _CommissionsCard({required this.pendingCommissions});

  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.outlined,
      padding: const EdgeInsets.all(SLSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SLColors.warning.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.people, color: SLColors.warning, size: 20),
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
                    color: SLColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: SLColors.textDisabled, size: 20),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// _TransactionCard
// ══════════════════════════════════════════════════════════════
class _TransactionCard extends StatelessWidget {
  final FinancialTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SLSpacing.sm),
      child: SLCard(
        variant: SLCardVariant.outlined,
        padding: const EdgeInsets.all(SLSpacing.md),
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
                      color: SLColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: SLSpacing.space1),
                  Text(
                    '${transaction.paymentMethod ?? '-'} · ${_formatTime(transaction.createdAt)}',
                    style: SLTypography.label.copyWith(
                      color: SLColors.textSecondary,
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

// ══════════════════════════════════════════════════════════════
// _ExpenseFormSheet
// ══════════════════════════════════════════════════════════════
class _ExpenseFormSheet extends StatefulWidget {
  final Future<void> Function(
    String description,
    String category,
    double amount,
    String paymentMethod,
    DateTime date,
    String? notes,
  ) onSave;

  const _ExpenseFormSheet({required this.onSave});

  @override
  State<_ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends State<_ExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedCategory = _expenseCategories.first;
  String _selectedPaymentMethod = 'pix';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(SLSpacing.lg, SLSpacing.lg, SLSpacing.lg, bottomInset + SLSpacing.lg),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Registrar Despesa',
                    style: SLTypography.h3.copyWith(
                      color: SLColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: SLColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.lg),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Descrição'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: SLSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: _inputDecoration('Categoria'),
                      items: _expenseCategories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c,
                                    style: SLTypography.body
                                        .copyWith(color: SLColors.textPrimary)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedCategory = v);
                      },
                    ),
                  ),
                  const SizedBox(width: SLSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Valor (R\$)'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if (double.tryParse(v) == null) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedPaymentMethod,
                      decoration: _inputDecoration('Pagamento'),
                      items: _paymentMethods
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(_paymentMethodLabel(m),
                                    style: SLTypography.body
                                        .copyWith(color: SLColors.textPrimary)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _selectedPaymentMethod = v);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: SLSpacing.md),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: SLColors.accentGold,
                                onPrimary: SLColors.textOnGold,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: _inputDecoration('Data'),
                        child: Text(
                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                          style: SLTypography.body.copyWith(
                            color: SLColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.md),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: _inputDecoration('Observações (opcional)'),
              ),
              const SizedBox(height: SLSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: SLButton(
                      variant: SLButtonVariant.text,
                      isExpanded: true,
                      onPressed: () => Navigator.pop(context),
                      label: 'Cancelar',
                    ),
                  ),
                  const SizedBox(width: SLSpacing.md),
                  Expanded(
                    child: SLButton(
                      variant: SLButtonVariant.primary,
                      isExpanded: true,
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _isSaving = true);
                              try {
                                final amount =
                                    double.parse(_amountController.text);
                                await widget.onSave(
                                  _descriptionController.text.trim(),
                                  _selectedCategory,
                                  amount,
                                  _selectedPaymentMethod,
                                  _selectedDate,
                                  _notesController.text.trim().isEmpty
                                      ? null
                                      : _notesController.text.trim(),
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Despesa registrada com sucesso'),
                                      backgroundColor: SLColors.stateSuccess,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro: $e'),
                                      backgroundColor: SLColors.stateError,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isSaving = false);
                              }
                            },
                      label: _isSaving ? 'Salvando...' : 'Salvar',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: SLRadius.card,
        borderSide: const BorderSide(color: SLColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: SLRadius.card,
        borderSide: const BorderSide(color: SLColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: SLRadius.card,
        borderSide: const BorderSide(color: SLColors.accentGold),
      ),
      filled: true,
      fillColor: SLColors.bgPrimary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.md,
        vertical: SLSpacing.sm,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Dialogs
// ══════════════════════════════════════════════════════════════
class _OpenCashRegisterDialog extends StatefulWidget {
  final Function(double) onConfirm;

  const _OpenCashRegisterDialog({required this.onConfirm});

  @override
  State<_OpenCashRegisterDialog> createState() =>
      _OpenCashRegisterDialogState();
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
        style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
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
                borderSide: const BorderSide(color: SLColors.accentGold),
              ),
            ),
          ),
        ],
      ),
      actions: [
        SLButton(
          variant: SLButtonVariant.text,
          isExpanded: false,
          onPressed: () => Navigator.pop(context),
          label: 'Cancelar',
        ),
        SLButton(
          variant: SLButtonVariant.primary,
          isExpanded: false,
          onPressed: () {
            final amount = double.tryParse(_controller.text) ?? 0;
            widget.onConfirm(amount);
            Navigator.pop(context);
          },
          label: 'Abrir',
        ),
      ],
    );
  }
}

class _CloseCashRegisterDialog extends StatefulWidget {
  final Function(double, String?) onConfirm;

  const _CloseCashRegisterDialog({required this.onConfirm});

  @override
  State<_CloseCashRegisterDialog> createState() =>
      _CloseCashRegisterDialogState();
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
        style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
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
                borderSide: const BorderSide(color: SLColors.accentGold),
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
                borderSide: const BorderSide(color: SLColors.accentGold),
              ),
            ),
          ),
        ],
      ),
      actions: [
        SLButton(
          variant: SLButtonVariant.text,
          isExpanded: false,
          onPressed: () => Navigator.pop(context),
          label: 'Cancelar',
        ),
        SLButton(
          variant: SLButtonVariant.primary,
          isExpanded: false,
          onPressed: () {
            final amount = double.tryParse(_amountController.text) ?? 0;
            final notes =
                _notesController.text.isEmpty ? null : _notesController.text;
            widget.onConfirm(amount, notes);
            Navigator.pop(context);
          },
          label: 'Fechar Caixa',
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Loading / Error
// ══════════════════════════════════════════════════════════════
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const SLCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(color: SLColors.accentGold),
        ),
      ),
    );
  }
}

class _LoadingQuickAction extends StatelessWidget {
  const _LoadingQuickAction();

  @override
  Widget build(BuildContext context) {
    return const SLCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(color: SLColors.accentGold),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return SLCard(
      padding: const EdgeInsets.all(SLSpacing.lg),
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
