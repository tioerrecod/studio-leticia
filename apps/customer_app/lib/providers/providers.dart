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

// ── Home Data ────────────────────────────────────────────
final homeDataProvider = Provider<HomeData>((ref) {
  return HomeData(
    studioName: 'Studio Letícia',
    tagline: 'Sua beleza, nossa história',
    heroImageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=1200',
    nextAppointment: null,
    upcomingServices: _mockServices,
    aiConciergeMessage: 'Olá! Notei que já faz 3 semanas desde sua última visita. Que tal agendar uma hidratação profunda? Seu cabelo agradece! 💆‍♀️',
    loyaltyPoints: 340,
    lifetimeVisits: 12,
  );
});

// ── Services ─────────────────────────────────────────────
final servicesProvider = Provider<List<ServiceItem>>((ref) {
  return _mockServices;
});

final professionalsProvider = Provider<List<Professional>>((ref) {
  return _mockProfessionals;
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

  void clear() => BookingServiceState();
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

// ── Mock Data ────────────────────────────────────────────
final List<ServiceItem> _mockServices = [
  ServiceItem(
    id: 's1',
    name: 'Corte Personalizado',
    description: 'Corte seco ou úmido com finalização personalizada para seu tipo de cabelo e estilo de vida.',
    duration: '60 min',
    price: 180,
    imageUrl: 'https://images.unsplash.com/photo-1560869713-7d0a29430803?w=600',
    isSignature: false,
    category: 'Corte',
  ),
  ServiceItem(
    id: 's2',
    name: 'Hidratação Premium',
    description: 'Tratamento profundo com queratina vegetal e óleos essenciais. Recupera a vitalidade dos fios.',
    duration: '90 min',
    price: 250,
    imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600',
    isSignature: true,
    category: 'Tratamento',
  ),
  ServiceItem(
    id: 's3',
    name: 'Coloração + Corte',
    description: 'Coloração profissional com pigmentos de alta durabilidade + corte personalizado.',
    duration: '150 min',
    price: 420,
    imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=600',
    isSignature: true,
    category: 'Química',
  ),
  ServiceItem(
    id: 's4',
    name: 'Escova Modeladora',
    description: 'Escova com finalização modeladora e proteção térmica. Resultado liso e brilhante.',
    duration: '45 min',
    price: 120,
    imageUrl: 'https://images.unsplash.com/photo-1596728325488-58c87691e9af?w=600',
    isSignature: false,
    category: 'Finalização',
  ),
  ServiceItem(
    id: 's5',
    name: 'Spa Capilar Experiência',
    description: 'Massagem relaxante, vapor de óleos essenciais, hidratação intensiva e finalização. Experiência completa de bem-estar.',
    duration: '120 min',
    price: 350,
    imageUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=600',
    isSignature: true,
    category: 'Spa',
  ),
];

final List<Professional> _mockProfessionals = [
  Professional(
    id: 'p1',
    name: 'Letícia',
    title: 'Fundadora & Hair Stylist Senior',
    avatarUrl: 'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?w=200',
    specialties: ['Corte', 'Coloração', 'Tratamentos'],
    rating: 4.9,
  ),
  Professional(
    id: 'p2',
    name: 'Camila',
    title: 'Hair Stylist Pleno',
    avatarUrl: 'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?w=200',
    specialties: ['Escova', 'Hidratação', 'Penteados'],
    rating: 4.8,
  ),
  Professional(
    id: 'p3',
    name: 'Juliana',
    title: 'Especialista em Química',
    avatarUrl: 'https://images.unsplash.com/photo-1602233158242-3ba0ac4d2167?w=200',
    specialties: ['Coloração', 'Progressiva', 'Reconstrução'],
    rating: 4.9,
  ),
];
