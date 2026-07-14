import 'package:core/core.dart';

class HomeData {
  final String studioName;
  final String tagline;
  final String heroImageUrl;
  final Appointment? nextAppointment;
  final List<ServiceItem> upcomingServices;
  final String? aiConciergeMessage;
  final int loyaltyPoints;
  final int lifetimeVisits;

  const HomeData({
    required this.studioName,
    required this.tagline,
    required this.heroImageUrl,
    this.nextAppointment,
    this.upcomingServices = const [],
    this.aiConciergeMessage,
    this.loyaltyPoints = 0,
    this.lifetimeVisits = 0,
  });
}
