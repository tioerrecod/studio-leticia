class AppUser {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String role; // 'customer' | 'professional' | 'admin'
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    role: json['role'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'role': role,
    'created_at': createdAt.toIso8601String(),
  };
}
