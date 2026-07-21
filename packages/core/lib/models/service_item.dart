class ServiceItem {
  final String id;
  final String name;
  final String description;
  final String duration;
  final double price;
  final String? imageUrl;
  final bool isSignature;
  final String category;
  final String? categoryId;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    this.imageUrl,
    this.isSignature = false,
    required this.category,
    this.categoryId,
  });

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(0)}';

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
    id: json['id'] as String,
    name: json['name'] as String,
    description: (json['description'] as String?) ?? '',
    duration: json['duration'] is int
        ? '${json['duration']} min'
        : (json['duration'] as String? ?? '0'),
    price: (json['price'] as num).toDouble(),
    imageUrl: json['image_url'] as String?,
    isSignature: json['is_signature'] as bool? ?? false,
    category: json['category'] is Map
        ? (json['category'] as Map)['name'] as String? ?? ''
        : (json['category'] as String? ?? ''),
    categoryId: json['category_id'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'duration': duration,
    'price': price,
    'image_url': imageUrl,
    'is_signature': isSignature,
    if (categoryId != null) 'category_id': categoryId,
  };

  Map<String, dynamic> toDatabaseJson() => {
    'id': id,
    'name': name,
    'description': description,
    'duration': int.tryParse(duration.replaceAll(' min', '')) ?? 0,
    'price': price,
    'image_url': imageUrl,
    'is_signature': isSignature,
    if (categoryId != null) 'category_id': categoryId,
  };

  factory ServiceItem.empty() => const ServiceItem(
    id: '',
    name: 'Servi\u00e7o n\u00e3o encontrado',
    description: '',
    duration: '0',
    price: 0,
    category: '',
  );
}
