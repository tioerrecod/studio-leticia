import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_item.dart';

class ServiceRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ServiceItem>> getServices() async {
    try {
      final response = await _supabase
          .from('services')
          .select('*, category:category_id(name)')
          .eq('is_active', true)
          .order('sort_order')
          .order('name');

      return (response as List)
          .map((json) => ServiceItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServiceException('Erro ao buscar serviços: $e');
    }
  }

  Future<ServiceItem> getServiceById(String id) async {
    try {
      final response = await _supabase
          .from('services')
          .select('*, category:category_id(name)')
          .eq('id', id)
          .single();

      return ServiceItem.fromJson(response);
    } catch (e) {
      throw ServiceException('Erro ao buscar serviço: $e');
    }
  }

  Future<List<ServiceItem>> getServicesByCategory(String categoryName) async {
    try {
      final response = await _supabase
          .from('services')
          .select('*, category:category_id!inner(name)')
          .eq('category.name', categoryName)
          .eq('is_active', true)
          .order('sort_order')
          .order('name');

      return (response as List)
          .map((json) => ServiceItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServiceException('Erro ao buscar serviços por categoria: $e');
    }
  }

  Future<List<ServiceItem>> getSignatureServices() async {
    try {
      final response = await _supabase
          .from('services')
          .select('*, category:category_id(name)')
          .eq('is_signature', true)
          .eq('is_active', true)
          .order('sort_order')
          .order('name');

      return (response as List)
          .map((json) => ServiceItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServiceException('Erro ao buscar serviços exclusivos: $e');
    }
  }

  Future<ServiceItem> createService(ServiceItem service) async {
    try {
      final response = await _supabase
          .from('services')
          .insert(service.toDatabaseJson())
          .select('*, category:category_id(name)')
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
          .update(service.toDatabaseJson())
          .eq('id', service.id)
          .select('*, category:category_id(name)')
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
