class Studio {
  final String id;
  final String name;
  final String? slogan;
  final String? logoUrl;
  final String? heroImageUrl;
  final String? primaryColor;
  final String? phone;
  final String? address;
  final String? instagram;
  final String? whatsapp;

  const Studio({
    required this.id,
    required this.name,
    this.slogan,
    this.logoUrl,
    this.heroImageUrl,
    this.primaryColor,
    this.phone,
    this.address,
    this.instagram,
    this.whatsapp,
  });

  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
    id: json['id'] as String,
    name: json['name'] as String,
    slogan: json['slogan'] as String?,
    logoUrl: json['logo_url'] as String?,
    heroImageUrl: json['hero_image_url'] as String?,
    primaryColor: json['primary_color'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    instagram: json['instagram'] as String?,
    whatsapp: json['whatsapp'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slogan': slogan,
    'logo_url': logoUrl,
    'hero_image_url': heroImageUrl,
    'primary_color': primaryColor,
    'phone': phone,
    'address': address,
    'instagram': instagram,
    'whatsapp': whatsapp,
  };
}
