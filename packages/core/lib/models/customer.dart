class Customer {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final DateTime? birthDate;
  final String? gender;
  final String? notes;
  final List<String> tags;
  final String source;
  final int totalVisits;
  final double totalSpent;
  final DateTime? lastVisitAt;
  final double ltv;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.birthDate,
    this.gender,
    this.notes,
    this.tags = const [],
    this.source = 'walkin',
    this.totalVisits = 0,
    this.totalSpent = 0,
    this.lastVisitAt,
    this.ltv = 0,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date'] as String) : null,
    gender: json['gender'] as String?,
    notes: json['notes'] as String?,
    tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    source: json['source'] as String? ?? 'walkin',
    totalVisits: json['total_visits'] as int? ?? 0,
    totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
    lastVisitAt: json['last_visit_at'] != null ? DateTime.parse(json['last_visit_at'] as String) : null,
    ltv: (json['ltv'] as num?)?.toDouble() ?? 0,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'birth_date': birthDate?.toIso8601String(),
    'gender': gender,
    'notes': notes,
    'tags': tags,
    'source': source,
    'total_visits': totalVisits,
    'total_spent': totalSpent,
    'last_visit_at': lastVisitAt?.toIso8601String(),
    'ltv': ltv,
    'created_at': createdAt.toIso8601String(),
  };

  String get formattedTotalSpent => 'R\$ ${totalSpent.toStringAsFixed(2)}';
  String get formattedLtv => 'R\$ ${ltv.toStringAsFixed(2)}';
  String get initials => name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
}