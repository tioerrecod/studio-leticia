class ServiceMedia {
  final String id;
  final String tenantId;
  final String serviceId;
  final String url;
  final String type;
  final String? caption;
  final bool isCover;
  final int sortOrder;
  final DateTime createdAt;

  const ServiceMedia({
    required this.id,
    required this.tenantId,
    required this.serviceId,
    required this.url,
    this.type = 'image',
    this.caption,
    this.isCover = false,
    this.sortOrder = 0,
    required this.createdAt,
  });

  bool get isVideo => type == 'video';

  ServiceMedia copyWith({
    String? id,
    String? tenantId,
    String? serviceId,
    String? url,
    String? type,
    String? caption,
    bool? isCover,
    int? sortOrder,
    DateTime? createdAt,
  }) => ServiceMedia(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    serviceId: serviceId ?? this.serviceId,
    url: url ?? this.url,
    type: type ?? this.type,
    caption: caption ?? this.caption,
    isCover: isCover ?? this.isCover,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );

  factory ServiceMedia.fromJson(Map<String, dynamic> json) => ServiceMedia(
    id: json['id'] as String,
    tenantId: json['tenant_id'] as String,
    serviceId: json['service_id'] as String,
    url: json['url'] as String,
    type: json['type'] as String? ?? 'image',
    caption: json['caption'] as String?,
    isCover: json['is_cover'] as bool? ?? false,
    sortOrder: json['sort_order'] as int? ?? 0,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'tenant_id': tenantId,
    'service_id': serviceId,
    'url': url,
    'type': type,
    'caption': caption,
    'is_cover': isCover,
    'sort_order': sortOrder,
    'created_at': createdAt.toIso8601String(),
  };

  Map<String, dynamic> toDatabaseJson() => {
    'tenant_id': tenantId,
    'service_id': serviceId,
    'url': url,
    'type': type,
    'caption': caption,
    'is_cover': isCover,
    'sort_order': sortOrder,
  };
}

class ServiceMediaException implements Exception {
  final String message;
  const ServiceMediaException(this.message);

  @override
  String toString() => message;
}
