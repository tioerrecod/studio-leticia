import 'package:flutter_test/flutter_test.dart';
import 'package:studio_leticia/models/models.dart';

void main() {
  group('Service', () {
    test('formattedPrice formats correctly', () {
      final service = Service(
        id: 'test',
        name: 'Test',
        description: 'Desc',
        duration: '60 min',
        price: 180,
      );
      expect(service.formattedPrice, 'R\$ 180');
    });

    test('isSignature defaults to false', () {
      final service = Service(
        id: 'test',
        name: 'Test',
        description: 'Desc',
        duration: '60 min',
        price: 100,
      );
      expect(service.isSignature, false);
    });
  });

  group('Professional', () {
    test('can be created without avatar', () {
      final pro = Professional(id: '1', name: 'Ana');
      expect(pro.avatarUrl, isNull);
    });
  });

  group('Appointment', () {
    test('formattedTime formats correctly', () {
      final date = DateTime(2026, 7, 15, 14, 30);
      final service = Service(
        id: 'test', name: 'Test', description: 'Desc',
        duration: '60 min', price: 100,
      );
      final apt = Appointment(
        customerName: 'Rafaela',
        service: service,
        dateTime: date,
      );
      expect(apt.formattedTime, '14:30');
    });
  });

  group('HomeData', () {
    test('can be created without optional fields', () {
      final data = HomeData(
        heroImageUrl: '',
        studioName: 'Studio',
        upcomingServices: const [],
        loyaltyPoints: 0,
        lifetimeVisits: 0,
      );
      expect(data.nextAppointment, isNull);
      expect(data.aiConciergeMessage, isNull);
    });
  });
}
