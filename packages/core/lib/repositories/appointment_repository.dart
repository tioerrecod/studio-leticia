import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';

class AppointmentRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Appointment>> getAppointments({String? customerId, String? status}) async {
    try {
      var query = _supabase
          .from('appointments')
          .select('*, service:services(*), professional:professionals(*)');

      if (customerId != null) {
        query = query.eq('customer_id', customerId);
      }
      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query.order('date_time', ascending: false);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw AppointmentException('Erro ao buscar agendamentos: $e');
    }
  }

  Future<List<Appointment>> getUpcomingAppointments({required String customerId}) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select('*, service:services(*), professional:professionals(*)')
          .eq('customer_id', customerId)
          .inFilter('status', ['scheduled', 'confirmed'])
          .gte('date_time', DateTime.now().toIso8601String())
          .order('date_time');

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw AppointmentException('Erro ao buscar próximos agendamentos: $e');
    }
  }

  Future<List<Appointment>> getCompletedAppointments({required String customerId}) async {
    try {
      final response = await _supabase
          .from('appointments')
          .select('*, service:services(*), professional:professionals(*)')
          .eq('customer_id', customerId)
          .eq('status', 'completed')
          .order('date_time', ascending: false);

      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      throw AppointmentException('Erro ao buscar histórico: $e');
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final serviceId = appointment.service?.id;
      final professionalId = appointment.professional?.id;
      final dateTimeStr = appointment.dateTime?.toIso8601String() ?? appointment.startAt.toIso8601String();

      if (serviceId == null || professionalId == null) {
        throw AppointmentException('Serviço e profissional são obrigatórios');
      }

      final response = await _supabase.functions.invoke(
        'create-appointment',
        body: {
          'serviceId': serviceId,
          'professionalId': professionalId,
          'dateTime': dateTimeStr,
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

  Future<Appointment> updateAppointment(String id, {String? status, double? rating, String? feedback}) async {
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
          .select('*, service:services(*), professional:professionals(*)')
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
