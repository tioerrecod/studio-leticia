import 'service_item.dart';
import 'professional.dart';

class Appointment {
  final String id;
  final String? studioId;
  final String customerName;
  final ServiceItem service;
  final Professional professional;
  final DateTime dateTime;
  final String status; // 'scheduled' | 'confirmed' | 'in_progress' | 'completed' | 'cancelled'
  final String? notes;
  final double? rating;
  final String? feedback;

  const Appointment({
    required this.id,
    this.studioId,
    required this.customerName,
    required this.service,
    required this.professional,
    required this.dateTime,
    required this.status,
    this.notes,
    this.rating,
    this.feedback,
  });

  String get formattedTime {
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDate {
    final months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
    return '${dateTime.day} ${months[dateTime.month - 1]}';
  }

  Duration get countdown => dateTime.difference(DateTime.now());

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] as String,
    studioId: json['studio_id'] as String?,
    customerName: json['customer_name'] as String,
    service: ServiceItem.fromJson(json['service'] as Map<String, dynamic>),
    professional: Professional.fromJson(json['professional'] as Map<String, dynamic>),
    dateTime: DateTime.parse(json['date_time'] as String),
    status: json['status'] as String,
    notes: json['notes'] as String?,
    rating: (json['rating'] as num?)?.toDouble(),
    feedback: json['feedback'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'studio_id': studioId,
    'customer_name': customerName,
    'service': service.toJson(),
    'professional': professional.toJson(),
    'date_time': dateTime.toIso8601String(),
    'status': status,
    'notes': notes,
    'rating': rating,
    'feedback': feedback,
  };
}
