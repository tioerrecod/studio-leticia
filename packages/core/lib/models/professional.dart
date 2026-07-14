class Professional {
  final String id;
  final String name;
  final String? title;
  final String? avatarUrl;
  final String? bio;
  final List<String> specialties;
  final double? rating;

  const Professional({
    required this.id,
    required this.name,
    this.title,
    this.avatarUrl,
    this.bio,
    this.specialties = const [],
    this.rating,
  });

  factory Professional.fromJson(Map<String, dynamic> json) => Professional(
    id: json['id'] as String,
    name: json['name'] as String,
    title: json['title'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    bio: json['bio'] as String?,
    specialties: (json['specialties'] as List<dynamic>?)?.cast<String>() ?? [],
    rating: (json['rating'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'avatar_url': avatarUrl,
    'bio': bio,
    'specialties': specialties,
    'rating': rating,
  };
}
