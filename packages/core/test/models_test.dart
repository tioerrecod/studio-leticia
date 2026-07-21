import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('ServiceItem', () {
    test('fromJson creates valid ServiceItem', () {
      final json = {
        'id': 's1',
        'name': 'Corte',
        'description': 'Corte personalizado',
        'duration': '60 min',
        'price': 180.0,
        'image_url': 'https://example.com/img.jpg',
        'is_signature': false,
        'category': 'Corte',
      };

      final item = ServiceItem.fromJson(json);

      expect(item.id, 's1');
      expect(item.name, 'Corte');
      expect(item.duration, '60 min');
      expect(item.price, 180.0);
      expect(item.isSignature, false);
    });

    test('toJson returns correct map', () {
      const item = ServiceItem(
        id: 's1',
        name: 'Corte',
        description: 'Desc',
        duration: '60 min',
        price: 180,
        category: 'Corte',
      );

      final json = item.toJson();

      expect(json['id'], 's1');
      expect(json['duration'], '60 min');
      expect(json['price'], 180);
    });

    test('formattedPrice returns correct format', () {
      const item = ServiceItem(
        id: 's1',
        name: 'Test',
        description: 'Test',
        duration: '60 min',
        price: 250,
        category: 'Test',
      );

      expect(item.formattedPrice, 'R\$ 250');
    });

    test('empty factory creates valid empty ServiceItem', () {
      final item = ServiceItem.empty();

      expect(item.id, '');
      expect(item.name, 'Serviço não encontrado');
      expect(item.price, 0);
    });
  });

  group('Professional', () {
    test('fromJson creates valid Professional', () {
      final json = {
        'id': 'p1',
        'name': 'Letícia',
        'title': 'Stylist',
        'avatar_url': 'https://example.com/avatar.jpg',
        'bio': 'Bio text',
        'specialties': ['Corte', 'Coloração'],
        'rating': 4.9,
      };

      final pro = Professional.fromJson(json);

      expect(pro.id, 'p1');
      expect(pro.name, 'Letícia');
      expect(pro.specialties, ['Corte', 'Coloração']);
      expect(pro.rating, 4.9);
    });

    test('toJson returns correct map', () {
      const pro = Professional(
        id: 'p1',
        name: 'Letícia',
        title: 'Stylist',
        specialties: ['Corte'],
        rating: 4.9,
      );

      final json = pro.toJson();

      expect(json['id'], 'p1');
      expect(json['name'], 'Letícia');
      expect(json['specialties'], ['Corte']);
    });
  });

  group('AppUser', () {
    test('fromJson creates valid AppUser', () {
      final json = {
        'id': 'u1',
        'name': 'Rafaela',
        'email': 'rafaela@email.com',
        'phone': '+5511999999999',
        'avatar_url': null,
        'role': 'customer',
        'created_at': '2025-06-01T10:00:00.000Z',
      };

      final user = AppUser.fromJson(json);

      expect(user.id, 'u1');
      expect(user.name, 'Rafaela');
      expect(user.role, 'customer');
    });

    test('toJson returns correct map', () {
      final user = AppUser(
        id: 'u1',
        name: 'Rafaela',
        email: 'rafaela@email.com',
        role: 'customer',
        createdAt: DateTime(2025, 6, 1),
      );

      final json = user.toJson();

      expect(json['id'], 'u1');
      expect(json['name'], 'Rafaela');
      expect(json['role'], 'customer');
    });
  });

  group('Studio', () {
    test('fromJson creates valid Studio', () {
      final json = {
        'id': 'st1',
        'name': 'Studio Letícia',
        'slogan': 'Sua beleza',
        'logo_url': null,
        'hero_image_url': null,
        'primary_color': '#D4A574',
        'phone': null,
        'address': null,
        'instagram': null,
        'whatsapp': null,
      };

      final studio = Studio.fromJson(json);

      expect(studio.id, 'st1');
      expect(studio.name, 'Studio Letícia');
      expect(studio.primaryColor, '#D4A574');
    });
  });

  group('Appointment', () {
    test('fromJson creates valid Appointment', () {
      final json = {
        'id': 'a1',
        'customer_name': 'Rafaela',
        'service': {
          'id': 's1',
          'name': 'Corte',
          'description': 'Desc',
          'duration': '60 min',
          'price': 180.0,
          'is_signature': false,
          'category': 'Corte',
        },
        'professional': {
          'id': 'p1',
          'name': 'Letícia',
          'title': 'Stylist',
          'specialties': ['Corte'],
          'rating': 4.9,
        },
        'date_time': '2026-07-15T14:00:00.000Z',
        'status': 'scheduled',
        'notes': null,
        'rating': null,
        'feedback': null,
      };

      final appointment = Appointment.fromJson(json);

      expect(appointment.id, 'a1');
      expect(appointment.customerName, 'Rafaela');
      expect(appointment.service?.name, 'Corte');
      expect(appointment.professional?.name, 'Letícia');
      expect(appointment.status, 'scheduled');
    });

    test('formattedTime returns correct format', () {
      final appointment = Appointment(
        id: 'a1',
        customerName: 'Test',
        professionalId: 'p1',
        startAt: DateTime(2026, 7, 15, 14, 30),
        status: 'scheduled',
        createdAt: DateTime(2026, 7, 15),
      );

      expect(appointment.formattedTime, '14:30');
    });

    test('formattedDate returns correct format', () {
      final appointment = Appointment(
        id: 'a1',
        customerName: 'Test',
        professionalId: 'p1',
        startAt: DateTime(2026, 7, 15),
        status: 'scheduled',
        createdAt: DateTime(2026, 7, 15),
      );

      expect(appointment.formattedDate, '15 jul 2026');
    });
  });

  group('ExperienceStage', () {
    test('enum has correct values', () {
      expect(ExperienceStage.values.length, 3);
      expect(ExperienceStage.before.name, 'before');
      expect(ExperienceStage.during.name, 'during');
      expect(ExperienceStage.after.name, 'after');
    });
  });

  group('LoyaltyTier', () {
    test('fromJson creates valid LoyaltyTier', () {
      final json = {
        'name': 'Ouro',
        'color': '#D4A574',
        'min_points': 200,
        'max_points': 500,
        'benefits': ['10% desconto', 'Brinde aniversário'],
      };

      final tier = LoyaltyTier.fromJson(json);

      expect(tier.name, 'Ouro');
      expect(tier.minPoints, 200);
      expect(tier.benefits.length, 2);
    });
  });
}
