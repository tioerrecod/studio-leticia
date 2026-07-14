class ServiceItem {
  final String id;
  final String name;
  final String description;
  final String duration;
  final double price;
  final String? imageUrl;
  final bool isSignature;
  final String category;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    this.imageUrl,
    this.isSignature = false,
    required this.category,
  });

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(0)}';

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    duration: json['duration'] as String,
    price: (json['price'] as num).toDouble(),
    imageUrl: json['image_url'] as String?,
    isSignature: json['is_signature'] as bool? ?? false,
    category: json['category'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'duration': duration,
    'price': price,
    'image_url': imageUrl,
    'is_signature': isSignature,
    'category': category,
  };

  factory ServiceItem.empty() => const ServiceItem(
    id: '',
    name: 'Serviço não encontrado',
    description: '',
    duration: '0',
    price: 0,
    category: '',
  );
}
