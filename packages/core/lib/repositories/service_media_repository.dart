import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_media.dart';

class ServiceMediaRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ServiceMedia>> getServiceMedia(String serviceId) async {
    try {
      final response = await _supabase
          .from('service_media')
          .select()
          .eq('service_id', serviceId)
          .order('sort_order')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ServiceMedia.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServiceMediaException('Erro ao buscar mídias: $e');
    }
  }

  Future<List<ServiceMedia>> getServiceMediaByTenant(String tenantId) async {
    try {
      final response = await _supabase
          .from('service_media')
          .select('*, service:service_id(name)')
          .eq('tenant_id', tenantId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ServiceMedia.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServiceMediaException('Erro ao buscar mídias: $e');
    }
  }

  Future<ServiceMedia> addServiceMedia(ServiceMedia media) async {
    try {
      final response = await _supabase
          .from('service_media')
          .insert(media.toDatabaseJson())
          .select()
          .single();

      return ServiceMedia.fromJson(response);
    } catch (e) {
      throw ServiceMediaException('Erro ao adicionar mídia: $e');
    }
  }

  Future<void> updateServiceMedia(String id, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from('service_media')
          .update(data)
          .eq('id', id);
    } catch (e) {
      throw ServiceMediaException('Erro ao atualizar mídia: $e');
    }
  }

  Stream<List<ServiceMedia>> watchServiceMedia(String serviceId) {
    return _supabase
        .from('service_media')
        .stream(primaryKey: ['id'])
        .eq('service_id', serviceId)
        .order('sort_order')
        .map((rows) => rows.map((r) => ServiceMedia.fromJson(r)).toList());
  }

  Future<void> setCover(String id, String serviceId) async {
    try {
      await _supabase
          .from('service_media')
          .update({'is_cover': false})
          .eq('service_id', serviceId);

      await _supabase
          .from('service_media')
          .update({'is_cover': true})
          .eq('id', id);
    } catch (e) {
      throw ServiceMediaException('Erro ao definir capa: $e');
    }
  }

  Future<void> deleteServiceMedia(String id) async {
    try {
      await _supabase
          .from('service_media')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw ServiceMediaException('Erro ao remover mídia: $e');
    }
  }


}
