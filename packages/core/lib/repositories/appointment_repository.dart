import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';

/// Relationship map (DB schema):
///   appointments
///     ├── appointment_services  (junction: appointment_id → appointments.id)
///     │     └── services        (FK: service_id → services.id)
///     ├── professionals         (FK: professional_id → professionals.id)
///     └── customers             (FK: customer_id → customers.id)
class AppointmentRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const _selectQuery = '''
    *,
    appointment_services(
      *,
      service:service_id(*)
    ),
    professional:professionals(*)
  ''';

  Future<List<Appointment>> getAppointments({
    String? customerId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase
          .from('appointments')
          .select(_selectQuery);

      if (customerId != null) {
        query = query.eq('customer_id', customerId);
      }
      if (status != null) {
        query = query.eq('status', status);
      }
      if (startDate != null) {
        query = query.gte('start_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('start_at', endDate.toIso8601String());
      }

      final response = await query.order('start_at', ascending: false);

      return (response as List)
          .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw AppointmentException('Erro ao buscar agendamentos: $e');
    }
  }

  Future<List<Appointment>> getUpcomingAppointments({
    required String customerId,
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select(_selectQuery)
          .eq('customer_id', customerId)
          .inFilter('status', ['scheduled', 'confirmed'])
          .gte('start_at', DateTime.now().toIso8601String())
          .order('start_at')
          .limit(limit);

      return (response as List)
          .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw AppointmentException('Erro ao buscar próximos agendamentos: $e');
    }
  }

  Future<List<Appointment>> getCompletedAppointments({
    required String customerId,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select(_selectQuery)
          .eq('customer_id', customerId)
          .eq('status', 'completed')
          .order('start_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw AppointmentException('Erro ao buscar histórico: $e');
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final professionalId = appointment.professional?.id ?? appointment.professionalId;

      if (professionalId.isEmpty) {
        throw AppointmentException('Profissional é obrigatório');
      }

      final response = await _supabase.functions.invoke(
        'create-appointment',
        body: {
          'professionalId': professionalId,
          'dateTime': appointment.startAt.toIso8601String(),
          'notes': appointment.notes,
        },
      );

      if (response.status != 200) {
        final error = response.data['error'] ?? 'Erro ao criar agendamento';
        throw AppointmentException(error);
      }

      final data = response.data['data'];
      return Appointment.fromJson(data);
    } catch (e) {
      if (e is AppointmentException) rethrow;
      throw AppointmentException('Erro ao criar agendamento: $e');
    }
  }

  Future<Appointment> updateAppointment(
    String id, {
    String? status,
    double? rating,
    String? feedback,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (status != null) updates['status'] = status;
      if (rating != null) updates['rating'] = rating;
      if (feedback != null) updates['feedback'] = feedback;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('appointments')
          .update(updates)
          .eq('id', id)
          .select(_selectQuery)
          .single();

      return Appointment.fromJson(response);
    } catch (e) {
      throw AppointmentException('Erro ao atualizar agendamento: $e');
    }
  }
}

class AppointmentException implements Exception {
  final String message;
  const AppointmentException(this.message);

  @override
  String toString() => message;
}
