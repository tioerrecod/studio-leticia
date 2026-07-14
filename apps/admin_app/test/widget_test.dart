import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('ServiceItem Model', () {
    test('should create ServiceItem from JSON', () {
      final json = {
        'id': '123',
        'name': 'Corte Feminino',
        'description': 'Corte moderno e estiloso',
        'duration': 45,
        'price': 85.0,
        'category': 'Cabelo',
        'is_signature': true,
        'image_url': 'https://example.com/image.jpg',
      };

      final service = ServiceItem.fromJson(json);

      expect(service.id, '123');
      expect(service.name, 'Corte Feminino');
      expect(service.description, 'Corte moderno e estiloso');
      expect(service.duration, 45);
      expect(service.price, 85.0);
      expect(service.category, 'Cabelo');
      expect(service.isSignature, true);
    });

    test('should format price correctly', () {
      final service = ServiceItem(
        id: '123',
        name: 'Corte Feminino',
        description: 'Descrição',
        duration: 45,
        price: 85.0,
        category: 'Cabelo',
        isSignature: false,
      );

      expect(service.formattedPrice, 'R\$ 85,00');
    });

    test('should handle nullable fields', () {
      final json = {
        'id': '123',
        'name': 'Corte Feminino',
        'duration': 45,
        'price': 85.0,
        'category': 'Cabelo',
      };

      final service = ServiceItem.fromJson(json);

      expect(service.description, isNull);
      expect(service.imageUrl, isNull);
      expect(service.isSignature, false);
    });
  });

  group('Professional Model', () {
    test('should create Professional from JSON', () {
      final json = {
        'id': '123',
        'name': 'Ana Silva',
        'specialty': 'Cabeleireira',
        'avatar_url': 'https://example.com/avatar.jpg',
        'is_active': true,
      };

      final professional = Professional.fromJson(json);

      expect(professional.id, '123');
      expect(professional.name, 'Ana Silva');
      expect(professional.specialty, 'Cabeleireira');
      expect(professional.isActive, true);
    });
  });
}
