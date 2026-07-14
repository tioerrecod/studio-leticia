import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock data providers for admin dashboard

final dashboardMetricsProvider = Provider<DashboardMetrics>((ref) {
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
