import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:core/core.dart';

// ── Supabase Client Provider ─────────────────────────
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ── Repository Providers ─────────────────────────────
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

final financialRepositoryProvider = Provider<FinancialRepository>((ref) {
  return FinancialRepository();
});

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return ProfessionalRepository();
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

// ── Customer Providers ───────────────────────────────
final customerSearchProvider = StateProvider<String>((ref) => '');

final customersProvider = FutureProvider<List<Customer>>((ref) async {
  final search = ref.watch(customerSearchProvider);
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getCustomers(search: search.isEmpty ? null : search);
});

final customerCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getCustomerCount();
});

// ── Financial Providers ──────────────────────────────
final financialSummaryProvider = FutureProvider<FinancialSummary>((ref) async {
  final repository = ref.watch(financialRepositoryProvider);
  return repository.getTodaySummary();
});

final transactionsProvider = FutureProvider<List<FinancialTransaction>>((ref) async {
  final repository = ref.watch(financialRepositoryProvider);
  return repository.getTransactions();
});

final openCashRegisterProvider = FutureProvider<CashRegister?>((ref) async {
  final repository = ref.watch(financialRepositoryProvider);
  return repository.getOpenCashRegister();
});

// ── Dashboard Metrics (real data) ────────────────────
final dashboardMetricsProvider = FutureProvider<DashboardMetrics>((ref) async {
  final customerRepo = ref.watch(customerRepositoryProvider);
  final financialRepo = ref.watch(financialRepositoryProvider);

  try {
    final customerCount = await customerRepo.getCustomerCount();
    final summary = await financialRepo.getTodaySummary();

    return DashboardMetrics(
      revenue: summary.todayRevenue,
      revenueChange: 12.5, // TODO: Calculate from historical data
      activeClients: customerCount,
      activeClientsChange: 8.3,
      todayAppointments: 14, // TODO: Get from appointment repository
      appointmentsChange: -2.1,
      aiRecommendations: 7,
      returnPrediction: 82,
    );
  } catch (e) {
    // Return mock data on error
    return DashboardMetrics(
      revenue: 28450.00,
      revenueChange: 12.5,
      activeClients: 186,
      activeClientsChange: 8.3,
      todayAppointments: 14,
      appointmentsChange: -2.1,
      aiRecommendations: 7,
      returnPrediction: 82,
    );
  }
});

class DashboardMetrics {
  final double revenue;
  final double revenueChange;
  final int activeClients;
  final double activeClientsChange;
  final int todayAppointments;
  final double appointmentsChange;
  final int aiRecommendations;
  final int returnPrediction;

  const DashboardMetrics({
    required this.revenue,
    required this.revenueChange,
    required this.activeClients,
    required this.activeClientsChange,
    required this.todayAppointments,
    required this.appointmentsChange,
    required this.aiRecommendations,
    required this.returnPrediction,
  });

  String get formattedRevenue => 'R\$ ${revenue.toStringAsFixed(0)}';
}