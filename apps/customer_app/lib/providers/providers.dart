import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/home_data.dart';
import 'supabase_providers.dart';

// ── Auth ─────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final bool hasCompletedOnboarding;
  final AppUser? user;

  const AuthState({
    this.isAuthenticated = false,
    this.hasCompletedOnboarding = false,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? hasCompletedOnboarding,
    AppUser? user,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    user: user ?? this.user,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void completeOnboarding(AppUser user) {
    state = state.copyWith(
      isAuthenticated: true,
      hasCompletedOnboarding: true,
      user: user,
    );
  }
}

// ── Home Data (Supabase) ────────────────────────────────
final homeDataProvider = FutureProvider<HomeData>((ref) async {
  final servicesAsync = ref.watch(servicesFromSupabaseProvider);
  final upcomingAsync = ref.watch(upcomingAppointmentsProvider);

  final services = servicesAsync.valueOrNull ?? [];
  final upcoming = upcomingAsync.valueOrNull ?? [];
  final nextAppointment = upcoming.isNotEmpty ? upcoming.first : null;

  return HomeData(
    studioName: 'Studio Letícia',
    tagline: 'Sua beleza, nossa história',
    heroImageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=1200',
    nextAppointment: nextAppointment,
    upcomingServices: services,
    aiConciergeMessage: 'Olá! Notei que já faz 3 semanas desde sua última visita. Que tal agendar uma hidratação profunda? Seu cabelo agradece!',
    loyaltyPoints: 340,
    lifetimeVisits: 12,
  );
});

// ── Services (Supabase) ─────────────────────────────────
final servicesProvider = Provider<List<ServiceItem>>((ref) {
  return ref.watch(servicesFromSupabaseProvider).valueOrNull ?? [];
});

final professionalsProvider = Provider<List<Professional>>((ref) {
  return ref.watch(professionalsFromSupabaseProvider).valueOrNull ?? [];
});

// ── Booking State ──────────────────────────────────────
final bookingServiceProvider = StateNotifierProvider<BookingServiceNotifier, BookingServiceState>((ref) {
  return BookingServiceNotifier();
});

class BookingServiceState {
  final ServiceItem? service;
  final Professional? professional;
  final String? time;
  final String? notes;

  const BookingServiceState({
    this.service,
    this.professional,
    this.time,
    this.notes,
  });

  bool get isComplete => service != null && professional != null && time != null;

  BookingServiceState copyWith({
    ServiceItem? service,
    Professional? professional,
    String? time,
    String? notes,
  }) => BookingServiceState(
    service: service ?? this.service,
    professional: professional ?? this.professional,
    time: time ?? this.time,
    notes: notes ?? this.notes,
  );
}

class BookingServiceNotifier extends StateNotifier<BookingServiceState> {
  BookingServiceNotifier() : super(const BookingServiceState());

  void setService(ServiceItem service) {
    state = state.copyWith(service: service);
  }

  void setProfessional(Professional professional) {
    state = state.copyWith(professional: professional);
  }

  void setTime(String time) {
    state = state.copyWith(time: time);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void clear() {
    state = const BookingServiceState();
  }
}
