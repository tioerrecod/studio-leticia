import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer.dart';

class CustomerRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Customer>> getCustomers({String? search}) async {
    try {
      var query = _supabase
          .from('customers')
          .select()
          .isFilter('deleted_at', null);

      if (search != null && search.isNotEmpty) {
        query = query.or('name.ilike.%$search%,email.ilike.%$search%,phone.ilike.%$search%');
      }

      final response = await query.order('name');

      return (response as List)
          .map((json) => Customer.fromJson(json))
          .toList();
    } catch (e) {
      throw CustomerException('Erro ao buscar clientes: $e');
    }
  }

  Future<Customer> getCustomerById(String id) async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .eq('id', id)
          .isFilter('deleted_at', null)
          .single();

      return Customer.fromJson(response);
    } catch (e) {
      throw CustomerException('Erro ao buscar cliente: $e');
    }
  }

  Future<Customer> getCustomerByPhone(String phone) async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .eq('phone', phone)
          .isFilter('deleted_at', null)
          .single();

      return Customer.fromJson(response);
    } catch (e) {
      throw CustomerException('Erro ao buscar cliente por telefone: $e');
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    try {
      final response = await _supabase
          .from('customers')
          .insert(customer.toJson()..remove('id'))
          .select()
          .single();

      return Customer.fromJson(response);
    } catch (e) {
      throw CustomerException('Erro ao criar cliente: $e');
    }
  }

  Future<Customer> updateCustomer(Customer customer) async {
    try {
      final response = await _supabase
          .from('customers')
          .update(customer.toJson())
          .eq('id', customer.id)
          .select()
          .single();

      return Customer.fromJson(response);
    } catch (e) {
      throw CustomerException('Erro ao atualizar cliente: $e');
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      // Soft delete - LGPD compliance
      await _supabase
          .from('customers')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } catch (e) {
      throw CustomerException('Erro ao deletar cliente: $e');
    }
  }

  Future<List<Customer>> getCustomersByTier(String tier) async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .isFilter('deleted_at', null)
          .order('total_spent', ascending: false);

      final customers = (response as List)
          .map((json) => Customer.fromJson(json))
          .toList();

      // Filter by tier based on total spent
      return customers.where((c) {
        switch (tier) {
          case 'PLATINA':
            return c.totalSpent >= 5000;
          case 'OURO':
            return c.totalSpent >= 2000 && c.totalSpent < 5000;
          case 'PRATA':
            return c.totalSpent >= 1000 && c.totalSpent < 2000;
          default:
            return c.totalSpent < 1000;
        }
      }).toList();
    } catch (e) {
      throw CustomerException('Erro ao buscar clientes por tier: $e');
    }
  }

  Future<int> getCustomerCount() async {
    try {
      final response = await _supabase
          .from('customers')
          .select('id')
          .isFilter('deleted_at', null);

      return (response as List).length;
    } catch (e) {
      throw CustomerException('Erro ao contar clientes: $e');
    }
  }

  Future<double> getTotalRevenue() async {
    try {
      final response = await _supabase
          .from('customers')
          .select('total_spent')
          .isFilter('deleted_at', null);

      double total = 0;
      for (final json in (response as List)) {
        total += (json['total_spent'] as num?)?.toDouble() ?? 0;
      }
      return total;
    } catch (e) {
      throw CustomerException('Erro ao calcular receita total: $e');
    }
  }
}

class CustomerException implements Exception {
  final String message;
  const CustomerException(this.message);

  @override
  String toString() => message;
}