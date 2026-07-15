import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/financial.dart';

class FinancialRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Payments ─────────────────────────────────────────
  Future<List<Payment>> getPayments({DateTime? startDate, DateTime? endDate}) async {
    try {
      var query = _supabase
          .from('payments')
          .select();

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => Payment.fromJson(json))
          .toList();
    } catch (e) {
      throw FinancialException('Erro ao buscar pagamentos: $e');
    }
  }

  Future<Payment> createPayment(Payment payment) async {
    try {
      final response = await _supabase
          .from('payments')
          .insert(payment.toJson()..remove('id'))
          .select()
          .single();

      return Payment.fromJson(response);
    } catch (e) {
      throw FinancialException('Erro ao criar pagamento: $e');
    }
  }

  Future<Payment> updatePaymentStatus(String id, String status) async {
    try {
      final response = await _supabase
          .from('payments')
          .update({
            'status': status,
            if (status == 'approved') 'paid_at': DateTime.now().toIso8601String(),
            if (status == 'refunded') 'refunded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return Payment.fromJson(response);
    } catch (e) {
      throw FinancialException('Erro ao atualizar pagamento: $e');
    }
  }

  // ── Financial Transactions ───────────────────────────
  Future<List<FinancialTransaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    try {
      var query = _supabase
          .from('financial_transactions')
          .select();

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }
      if (type != null) {
        query = query.eq('type', type);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => FinancialTransaction.fromJson(json))
          .toList();
    } catch (e) {
      throw FinancialException('Erro ao buscar transações: $e');
    }
  }

  Future<FinancialTransaction> createTransaction(FinancialTransaction transaction) async {
    try {
      final response = await _supabase
          .from('financial_transactions')
          .insert(transaction.toJson()..remove('id'))
          .select()
          .single();

      return FinancialTransaction.fromJson(response);
    } catch (e) {
      throw FinancialException('Erro ao criar transação: $e');
    }
  }

  // ── Commissions ──────────────────────────────────────
  Future<List<CommissionEntry>> getCommissions({String? professionalId}) async {
    try {
      var query = _supabase
          .from('commission_entries')
          .select();

      if (professionalId != null) {
        query = query.eq('professional_id', professionalId);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => CommissionEntry.fromJson(json))
          .toList();
    } catch (e) {
      throw FinancialException('Erro ao buscar comissões: $e');
    }
  }

  Future<CommissionEntry> updateCommissionStatus(String id, String status) async {
    try {
      final response = await _supabase
          .from('commission_entries')
          .update({
            'status': status,
            if (status == 'paid') 'paid_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return CommissionEntry.fromJson(response);
    } catch (e) {
      throw FinancialException('Erro ao atualizar comissão: $e');
    }
  }

  // ── Cash Register ────────────────────────────────────
  Future<CashRegister?> getOpenCashRegister() async {
    try {
      final response = await _supabase
          .from('cash_registers')
          .select()
          .eq('status', 'open')
          .order('opened_at', ascending: false)
          .maybeSingle();

      return response != null ? CashRegister.fromJson(response) : null;
    } catch (e) {
      throw FinancialException('Erro ao buscar caixa aberto: $e');
    }
  }

  Future<CashRegister> openCashRegister(double initialBalance) async {
    try {
      final response = await _supabase
          .from('cash_registers')
          .insert({
            'initial_balance': initialBalance,
            'status': 'open',
          })
          .select()
          .single();

      return CashRegister.fromJson(response);
    } catch (e) {
      throw FinancialException('Erro ao abrir caixa: $e');
    }
  }

  Future<CashRegister> closeCashRegister({
    required String id,
    required double actualBalance,
    String? notes,
  }) async {
    try {
      final register = await _supabase
          .from('cash_registers')
          .select()
          .eq('id', id)
          .single();

      final expectedBalance = (register['expected_balance'] as num?)?.toDouble() ?? 0;
      final difference = actualBalance - expectedBalance;

      final response = await _supabase
          .from('cash_registers')
          .update({
            'status': 'closed',
            'closed_at': DateTime.now().toIso8601String(),
            'actual_balance': actualBalance,
            'difference': difference,
            'notes': notes,
          })
          .eq('id', id)
          .select()
          .single();

      return CashRegister.fromJson(response);
    } catch (e) {
      throw FinancialException('Erro ao fechar caixa: $e');
    }
  }

  // ── Summary ──────────────────────────────────────────
  Future<FinancialSummary> getTodaySummary() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Get today's payments
      final payments = await getPayments(
        startDate: startOfDay,
        endDate: endOfDay,
      );

      // Calculate totals by method
      double pixTotal = 0;
      double cardTotal = 0;
      double cashTotal = 0;

      for (final payment in payments) {
        if (payment.status == 'approved') {
          switch (payment.method) {
            case 'pix':
              pixTotal += payment.amount;
              break;
            case 'credit_card':
            case 'debit_card':
              cardTotal += payment.amount;
              break;
            case 'cash':
              cashTotal += payment.amount;
              break;
          }
        }
      }

      final todayRevenue = pixTotal + cardTotal + cashTotal;

      // Get today's expenses
      final expenses = await getTransactions(
        startDate: startOfDay,
        endDate: endOfDay,
        type: 'expense',
      );
      final todayExpenses = expenses.fold(0.0, (sum, t) => sum + t.amount);

      // Get pending commissions
      final commissions = await getCommissions();
      final pendingCommissions = commissions
          .where((c) => c.status == 'pending')
          .fold(0.0, (sum, c) => sum + c.amount);

      return FinancialSummary(
        todayRevenue: todayRevenue,
        pixToday: pixTotal,
        cardToday: cardTotal,
        cashToday: cashTotal,
        todayExpenses: todayExpenses,
        pendingCommissions: pendingCommissions,
      );
    } catch (e) {
      throw FinancialException('Erro ao calcular resumo: $e');
    }
  }
}

class FinancialException implements Exception {
  final String message;
  const FinancialException(this.message);

  @override
  String toString() => message;
}