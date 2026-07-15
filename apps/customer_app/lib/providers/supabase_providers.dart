import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return ProfessionalRepository();
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository();
});

final servicesFromSupabaseProvider = FutureProvider<List<ServiceItem>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServices();
});

final professionalsFromSupabaseProvider = FutureProvider<List<Professional>>((ref) async {
  final repository = ref.watch(professionalRepositoryProvider);
  return repository.getProfessionals();
});

final servicesByCategoryProvider = FutureProvider.family<List<ServiceItem>, String>((ref, category) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServicesByCategory(category);
});

final upcomingAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final auth = ref.watch(authServiceProvider);
  if (auth.currentUser == null) return [];
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getUpcomingAppointments(customerId: auth.currentUser!.id);
});

final completedAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final auth = ref.watch(authServiceProvider);
  if (auth.currentUser == null) return [];
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getCompletedAppointments(customerId: auth.currentUser!.id);
});

// ── Profile ─────────────────────────────────────────────
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final auth = ref.watch(authServiceProvider);
  if (auth.currentUser == null) return null;

  try {
    final response = await Supabase.instance.client
        .from('users')
        .select('*')
        .eq('id', auth.currentUser!.id)
        .single();
    return response;
  } catch (e) {
    return null;
  }
});

final customerStyleProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final auth = ref.watch(authServiceProvider);
  if (auth.currentUser == null) return null;

  try {
    final response = await Supabase.instance.client
        .from('customer_styles')
        .select('*')
        .eq('customer_id', auth.currentUser!.id)
        .maybeSingle();
    return response;
  } catch (e) {
    return null;
  }
});

final customerMemoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final auth = ref.watch(authServiceProvider);
  if (auth.currentUser == null) return [];

  try {
    final response = await Supabase.instance.client
        .from('customer_memories')
        .select('*')
        .eq('customer_id', auth.currentUser!.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response as List);
  } catch (e) {
    return [];
  }
});

// ── Loyalty ─────────────────────────────────────────────
final loyaltyProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final auth = ref.watch(authServiceProvider);
  if (auth.currentUser == null) return null;

  try {
    final response = await Supabase.instance.client
        .from('loyalty_accounts')
        .select('*')
        .eq('customer_id', auth.currentUser!.id)
        .maybeSingle();
    return response;
  } catch (e) {
    return null;
  }
});
