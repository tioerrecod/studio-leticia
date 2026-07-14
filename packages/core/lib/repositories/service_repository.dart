import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_item.dart';

class ServiceRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ServiceItem>> getServices() async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .order('name');

      return (response as List)
          .map((json) => ServiceItem.fromJson(json))
          .toList();
    } catch (e) {
      throw ServiceException('Erro ao buscar serviços: $e');
    }
  }

  Future<ServiceItem> getServiceById(String id) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('id', id)
          .single();

      return ServiceItem.fromJson(response);
    } catch (e) {
      throw ServiceException('Erro ao buscar serviço: $e');
    }
  }

  Future<List<ServiceItem>> getServicesByCategory(String category) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('category', category)
          .order('name');

      return (response as List)
          .map((json) => ServiceItem.fromJson(json))
          .toList();
    } catch (e) {
      throw ServiceException('Erro ao buscar serviços por categoria: $e');
    }
  }

  Future<List<ServiceItem>> getSignatureServices() async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('is_signature', true)
          .order('name');

      return (response as List)
          .map((json) => ServiceItem.fromJson(json))
          .toList();
    } catch (e) {
      throw ServiceException('Erro ao buscar serviços exclusivos: $e');
    }
  }

  Future<ServiceItem> createService(ServiceItem service) async {
    try {
      final response = await _supabase
          .from('services')
          .insert(service.toJson())
          .select()
          .single();

      return ServiceItem.fromJson(response);
    } catch (e) {
      throw ServiceException('Erro ao criar serviço: $e');
    }
  }

  Future<ServiceItem> updateService(ServiceItem service) async {
    try {
      final response = await _supabase
          .from('services')
          .update(service.toJson())
          .eq('id', service.id)
          .select()
          .single();

      return ServiceItem.fromJson(response);
    } catch (e) {
      throw ServiceException('Erro ao atualizar serviço: $e');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _supabase
          .from('services')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw ServiceException('Erro ao deletar serviço: $e');
    }
  }
}

class ServiceException implements Exception {
  final String message;
  const ServiceException(this.message);

  @override
  String toString() => message;
}
