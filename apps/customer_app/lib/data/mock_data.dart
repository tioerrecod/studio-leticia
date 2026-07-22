import 'package:core/core.dart';
import '../models/home_data.dart';

final List<ServiceItem> mockServices = [
  ServiceItem(
    id: 'corte-personalizado',
    name: 'Corte Personalizado',
    description: 'Corte sob medida com diagnóstico capilar e acabamento perfeito.',
    duration: '60',
    price: 180,
    isSignature: true,
    category: 'Cortes',
  ),
  ServiceItem(
    id: 'box-braids',
    name: 'Box Braids',
    description: 'Tranças box braids médias com acabamento profissional.',
    duration: '180',
    price: 280,
    category: 'Tranças',
  ),
  ServiceItem(
    id: 'escova-modeladora',
    name: 'Escova Modeladora',
    description: 'Escova com modelagem e finalização profissional.',
    duration: '45',
    price: 120,
    category: 'Finalização',
  ),
  ServiceItem(
    id: 'spa-capilar',
    name: 'Spa Capilar Experiência',
    description: 'Ritual completo de relaxamento e tratamento capilar.',
    duration: '120',
    price: 350,
    isSignature: true,
    category: 'Experiências',
  ),
  ServiceItem(
    id: 'coloracao-corte',
    name: 'Coloração + Corte',
    description: 'Coloração personalizada com corte harmonizado.',
    duration: '150',
    price: 420,
    category: 'Cortes',
  ),
];

final List<Professional> mockProfessionals = [
  const Professional(id: 'leticia', name: 'Letícia'),
  const Professional(id: 'camila', name: 'Camila'),
  const Professional(id: 'ana', name: 'Ana'),
];

Appointment _buildAppointment({required int daysFromNow}) {
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day + daysFromNow, 14, 0);
  return Appointment(
    id: 'mock-${daysFromNow}',
    professionalId: 'leticia',
    startAt: date,
    status: 'scheduled',
    createdAt: now,
    customerName: 'Rafaela',
    service: mockServices.first,
    serviceName: mockServices.first.name,
    serviceDuration: int.tryParse(mockServices.first.duration),
    servicePrice: mockServices.first.price,
    professional: mockProfessionals.first,
    dateTime: date,
  );
}

HomeData mockHomeData({
  bool withAppointment = true,
  bool withAiMessage = true,
}) {
  return HomeData(
    studioName: 'Studio Letícia',
    tagline: 'Sua beleza, nossa história',
    heroImageUrl: '',
    nextAppointment: withAppointment
        ? _buildAppointment(daysFromNow: 2)
        : null,
    aiConciergeMessage: withAiMessage
        ? 'Baseado no seu perfil, recomendamos uma hidratação profunda antes do casamento. Que tal agendar?'
        : null,
    upcomingServices: mockServices,
    loyaltyPoints: 340,
    lifetimeVisits: 12,
  );
}
