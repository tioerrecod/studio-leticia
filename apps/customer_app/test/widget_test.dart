import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('AppUser Model', () {
    test('should create AppUser from JSON', () {
      final json = {
        'id': '123',
        'name': 'Maria Silva',
        'email': 'maria@example.com',
        'phone': '11999999999',
        'avatar_url': 'https://example.com/avatar.jpg',
        'role': 'customer',
        'created_at': '2024-01-15T10:30:00.000Z',
      };

      final user = AppUser.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'Maria Silva');
      expect(user.email, 'maria@example.com');
      expect(user.phone, '11999999999');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.role, 'customer');
    });

    test('should convert AppUser to JSON', () {
      final user = AppUser(
        id: '123',
        name: 'Maria Silva',
        email: 'maria@example.com',
        phone: '11999999999',
        avatarUrl: 'https://example.com/avatar.jpg',
        role: 'customer',
        createdAt: DateTime(2024, 1, 15, 10, 30, 0),
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Maria Silva');
      expect(json['email'], 'maria@example.com');
      expect(json['phone'], '11999999999');
      expect(json['avatar_url'], 'https://example.com/avatar.jpg');
      expect(json['role'], 'customer');
    });

    test('should handle nullable fields', () {
      final json = {
        'id': '123',
        'name': 'Maria Silva',
        'role': 'customer',
        'created_at': '2024-01-15T10:30:00.000Z',
      };

      final user = AppUser.fromJson(json);

      expect(user.email, isNull);
      expect(user.phone, isNull);
      expect(user.avatarUrl, isNull);
    });
  });
}
