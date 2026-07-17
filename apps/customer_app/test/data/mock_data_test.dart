import 'package:flutter_test/flutter_test.dart';
import 'package:studio_leticia/data/mock_data.dart';

void main() {
  group('mockData', () {
    test('mockServices contains 5 services', () {
      expect(mockServices.length, 5);
    });

    test('mockServices has corte-personalizado as first', () {
      final corte = mockServices.first;
      expect(corte.id, 'corte-personalizado');
      expect(corte.name, 'Corte Personalizado');
      expect(corte.isSignature, true);
    });

    test('mockServices last service has correct price', () {
      final last = mockServices.last;
      expect(last.price, 420);
      expect(last.formattedPrice, 'R\$ 420');
    });

    test('mockProfessionals contains 3 professionals', () {
      expect(mockProfessionals.length, 3);
    });

    test('mockProfessionals has Letícia as first', () {
      final leticia = mockProfessionals.first;
      expect(leticia.id, 'leticia');
      expect(leticia.name, 'Letícia');
    });

    test('mockHomeData returns full data by default', () {
      final data = mockHomeData();
      expect(data.studioName, 'Studio Letícia');
      expect(data.nextAppointment, isNotNull);
      expect(data.aiConciergeMessage, isNotNull);
      expect(data.upcomingServices.length, 5);
      expect(data.loyaltyPoints, 340);
      expect(data.lifetimeVisits, 12);
    });

    test('mockHomeData omits appointment when requested', () {
      final data = mockHomeData(withAppointment: false);
      expect(data.nextAppointment, isNull);
    });

    test('mockHomeData omits ai message when requested', () {
      final data = mockHomeData(withAiMessage: false);
      expect(data.aiConciergeMessage, isNull);
    });
  });
}
