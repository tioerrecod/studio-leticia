import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return ProfessionalRepository();
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
