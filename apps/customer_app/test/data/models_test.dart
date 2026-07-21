import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('ServiceItem', () {
    test('formattedPrice formats correctly', () {
      final service = ServiceItem(
        id: 'test',
        name: 'Test',
        description: 'Desc',
        duration: '60',
        price: 180,
        category: 'Test',
      );
      expect(service.formattedPrice, 'R\$ 180');
    });

    test('isSignature defaults to false', () {
      final service = ServiceItem(
        id: 'test',
        name: 'Test',
        description: 'Desc',
        duration: '60',
        price: 100,
        category: 'Test',
      );
      expect(service.isSignature, false);
    });
  });

  group('Professional', () {
    test('can be created without avatar', () {
      const pro = Professional(id: '1', name: 'Ana');
      expect(pro.avatarUrl, isNull);
    });
  });

  group('Appointment', () {
    test('formattedTime formats correctly', () {
      final date = DateTime(2026, 7, 15, 14, 30);
      final apt = Appointment(
        id: 'test',
        professionalId: '1',
        startAt: date,
        status: 'scheduled',
        createdAt: DateTime.now(),
      );
      expect(apt.formattedTime, '14:30');
    });
  });
}
