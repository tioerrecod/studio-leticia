import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/professional.dart';

class ProfessionalRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Professional>> getProfessionals() async {
    try {
      final response = await _supabase
          .from('professionals')
          .select()
          .eq('is_active', true)
          .order('name');

      return (response as List)
          .map((json) => Professional.fromJson(json))
          .toList();
    } catch (e) {
      throw ProfessionalException('Erro ao buscar profissionais: $e');
    }
  }

  Future<Professional> getProfessionalById(String id) async {
    try {
      final response = await _supabase
          .from('professionals')
          .select()
          .eq('id', id)
          .single();

      return Professional.fromJson(response);
    } catch (e) {
      throw ProfessionalException('Erro ao buscar profissional: $e');
    }
  }

  Future<List<Professional>> getProfessionalsBySpecialty(String specialty) async {
    try {
      final response = await _supabase
          .from('professionals')
          .select()
          .eq('is_active', true)
          .contains('specialties', [specialty])
          .order('name');

      return (response as List)
          .map((json) => Professional.fromJson(json))
          .toList();
    } catch (e) {
      throw ProfessionalException('Erro ao buscar profissionais por especialidade: $e');
    }
  }

  Future<Professional> createProfessional(Professional professional) async {
    try {
      final response = await _supabase
          .from('professionals')
          .insert(professional.toJson())
          .select()
          .single();

      return Professional.fromJson(response);
    } catch (e) {
      throw ProfessionalException('Erro ao criar profissional: $e');
    }
  }

  Future<Professional> updateProfessional(Professional professional) async {
    try {
      final response = await _supabase
          .from('professionals')
          .update(professional.toJson())
          .eq('id', professional.id)
          .select()
          .single();

      return Professional.fromJson(response);
    } catch (e) {
      throw ProfessionalException('Erro ao atualizar profissional: $e');
    }
  }

  Future<void> deleteProfessional(String id) async {
    try {
      await _supabase
          .from('professionals')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw ProfessionalException('Erro ao deletar profissional: $e');
    }
  }
}

class ProfessionalException implements Exception {
  final String message;
  const ProfessionalException(this.message);

  @override
  String toString() => message;
}
