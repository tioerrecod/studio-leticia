import 'service_item.dart';
import 'professional.dart';

class Appointment {
  final String id;
  final String? tenantId;
  final String? customerId;
  final String? customerName;
  final String professionalId;
  final Professional? professional;
  final DateTime startAt;
  final DateTime? endAt;
  final String status;
  final double? totalAmount;
  final double? commissionAmount;
  final String? source;
  final String? notes;
  final int rescheduleCount;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime createdAt;

  // For backward compatibility with simple appointments
  final ServiceItem? service;
  final String? serviceName;
  final int? serviceDuration;
  final double? servicePrice;
  final DateTime? dateTime;

  const Appointment({
    required this.id,
    this.tenantId,
    this.customerId,
    this.customerName,
    required this.professionalId,
    this.professional,
    required this.startAt,
    this.endAt,
    required this.status,
    this.totalAmount,
    this.commissionAmount,
    this.source,
    this.notes,
    this.rescheduleCount = 0,
    this.cancelledAt,
    this.cancellationReason,
    required this.createdAt,
    this.service,
    this.serviceName,
    this.serviceDuration,
    this.servicePrice,
    this.dateTime,
  });

  String get formattedTime {
    final h = startAt.hour.toString().padLeft(2, '0');
    final m = startAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDate {
    final months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
    return '${startAt.day} ${months[startAt.month - 1]} ${startAt.year}';
  }

  Duration get countdown => startAt.difference(DateTime.now());

  int get durationMinutes {
    if (endAt != null) {
      return endAt!.difference(startAt).inMinutes;
    }
    return serviceDuration ?? 0;
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    // Handle nested service and professional objects
    ServiceItem? service;
    Professional? professional;

    if (json['service'] is Map<String, dynamic>) {
      service = ServiceItem.fromJson(json['service']);
    }
    if (json['professional'] is Map<String, dynamic>) {
      professional = Professional.fromJson(json['professional']);
    }

    // Parse services JSONB array
    String? serviceName;
    int? serviceDuration;
    double? servicePrice;

    if (json['services'] is List && (json['services'] as List).isNotEmpty) {
      final firstService = (json['services'] as List).first as Map<String, dynamic>;
      serviceName = firstService['name'] as String?;
      serviceDuration = firstService['duration'] as int?;
      servicePrice = (firstService['price'] as num?)?.toDouble();
    } else if (service != null) {
      serviceName = service.name;
      serviceDuration = int.tryParse(service.duration);
      servicePrice = service.price;
    }

    // Parse date_time or start_at
    DateTime startAt;
    if (json['start_at'] != null) {
      startAt = DateTime.parse(json['start_at'] as String);
    } else if (json['date_time'] != null) {
      startAt = DateTime.parse(json['date_time'] as String);
    } else {
      startAt = DateTime.now();
    }

    return Appointment(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String?,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String?,
      professionalId: json['professional_id'] as String? ?? professional?.id ?? '',
      professional: professional,
      startAt: startAt,
      endAt: json['end_at'] != null ? DateTime.parse(json['end_at'] as String) : null,
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      commissionAmount: (json['commission_amount'] as num?)?.toDouble(),
      source: json['source'] as String?,
      notes: json['notes'] as String?,
      rescheduleCount: json['reschedule_count'] as int? ?? 0,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      service: service,
      serviceName: serviceName,
      serviceDuration: serviceDuration,
      servicePrice: servicePrice,
      dateTime: startAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tenant_id': tenantId,
    'customer_id': customerId,
    'customer_name': customerName,
    'professional_id': professionalId,
    'start_at': startAt.toIso8601String(),
    'end_at': endAt?.toIso8601String(),
    'status': status,
    'total_amount': totalAmount,
    'commission_amount': commissionAmount,
    'source': source,
    'notes': notes,
    'reschedule_count': rescheduleCount,
    'cancelled_at': cancelledAt?.toIso8601String(),
    'cancellation_reason': cancellationReason,
    'created_at': createdAt.toIso8601String(),
  };
}