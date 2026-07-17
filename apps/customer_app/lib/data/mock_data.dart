import '../models/models.dart';

final List<Service> mockServices = [
  const Service(
    id: 'corte-personalizado',
    name: 'Corte Personalizado',
    description: 'Corte sob medida com diagóstico capilar e acabamento perfeito.',
    duration: '60 min',
    price: 180,
    isSignature: true,
  ),
  const Service(
    id: 'hidratacao-premium',
    name: 'Hidratação Premium',
    description: 'Tratamento profundo com ácido hialurônico e queratina.',
    duration: '90 min',
    price: 250,
  ),
  const Service(
    id: 'escova-modeladora',
    name: 'Escova Modeladora',
    description: 'Escova com modelagem e finalização profissional.',
    duration: '45 min',
    price: 120,
  ),
  const Service(
    id: 'spa-capilar',
    name: 'Spa Capilar Experiência',
    description: 'Ritual completo de relaxamento e tratamento capilar.',
    duration: '120 min',
    price: 350,
    isSignature: true,
  ),
  const Service(
    id: 'coloracao-corte',
    name: 'Coloração + Corte',
    description: 'Coloração personalizada com corte harmonizado.',
    duration: '150 min',
    price: 420,
  ),
];

final List<Professional> mockProfessionals = [
  const Professional(id: 'leticia', name: 'Letícia'),
  const Professional(id: 'camila', name: 'Camila'),
  const Professional(id: 'ana', name: 'Ana'),
];

HomeData mockHomeData({
  bool withAppointment = true,
  bool withAiMessage = true,
}) {
  return HomeData(
    heroImageUrl: '',
    studioName: 'Studio Letícia',
    nextAppointment: withAppointment
        ? Appointment(
            customerName: 'Rafaela',
            service: mockServices.first,
            dateTime: DateTime.now().add(const Duration(days: 2)),
          )
        : null,
    aiConciergeMessage: withAiMessage
        ? 'Baseado no seu perfil, recomendamos uma hidratação profunda antes do casamento. Que tal agendar?'
        : null,
    upcomingServices: mockServices,
    loyaltyPoints: 340,
    lifetimeVisits: 12,
  );
}
