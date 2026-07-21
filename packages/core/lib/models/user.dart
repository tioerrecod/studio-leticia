class AppUser {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String role; // 'customer' | 'professional' | 'admin'
  final String? tenantId;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.role,
    this.tenantId,
    required this.createdAt,
  });

  bool get isAdmin => ['admin', 'super_admin_1', 'super_admin_2', 'system_owner'].contains(role);

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    role: json['role'] is Map ? (json['role'] as Map)['name'] as String : json['role'] as String? ?? 'customer',
    tenantId: json['tenant_id'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'role': role,
    'tenant_id': tenantId,
    'created_at': createdAt.toIso8601String(),
  };
}
