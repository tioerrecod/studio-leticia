import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('ServiceItem Model', () {
    test('should create ServiceItem from JSON', () {
      final json = {
        'id': '123',
        'name': 'Corte Feminino',
        'description': 'Corte moderno e estiloso',
        'duration': '45 min',
        'price': 85.0,
        'category': 'Cabelo',
        'is_signature': true,
        'image_url': 'https://example.com/image.jpg',
      };

      final service = ServiceItem.fromJson(json);

      expect(service.id, '123');
      expect(service.name, 'Corte Feminino');
      expect(service.description, 'Corte moderno e estiloso');
      expect(service.duration, '45 min');
      expect(service.price, 85.0);
      expect(service.category, 'Cabelo');
      expect(service.isSignature, true);
    });

    test('should format price correctly', () {
      const service = ServiceItem(
        id: '123',
        name: 'Corte Feminino',
        description: 'Descricao',
        duration: '45 min',
        price: 85.0,
        category: 'Cabelo',
      );

      expect(service.formattedPrice, 'R\$ 85');
    });

    test('should handle nullable fields', () {
      final json = {
        'id': '123',
        'name': 'Corte Feminino',
        'description': 'Descricao',
        'duration': '45 min',
        'price': 85.0,
        'category': 'Cabelo',
      };

      final service = ServiceItem.fromJson(json);

      expect(service.imageUrl, isNull);
      expect(service.isSignature, false);
    });
  });

  group('Professional Model', () {
    test('should create Professional from JSON', () {
      final json = {
        'id': '123',
        'name': 'Ana Silva',
        'title': 'Cabeleireira',
        'avatar_url': 'https://example.com/avatar.jpg',
        'specialties': ['Corte', 'Coloracao'],
        'rating': 4.8,
      };

      final professional = Professional.fromJson(json);

      expect(professional.id, '123');
      expect(professional.name, 'Ana Silva');
      expect(professional.title, 'Cabeleireira');
      expect(professional.specialties, ['Corte', 'Coloracao']);
    });
  });
}
