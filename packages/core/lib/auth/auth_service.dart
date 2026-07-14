import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  AppUser? _currentUser;
  User? _authUser;

  AppUser? get currentUser => _currentUser;
  User? get authUser => _authUser;
  bool get isAuthenticated => _authUser != null;

  GoTrueClient get _auth => _supabase.auth;

  AuthService() {
    _auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _authUser = session.user;
        _loadUserProfile(session.user.id);
      } else {
        _authUser = null;
        _currentUser = null;
      }
    });
  }

  Future<void> initialize() async {
    final session = _auth.currentSession;
    if (session != null) {
      _authUser = session.user;
      await _loadUserProfile(session.user.id);
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      _currentUser = AppUser.fromJson(response);
    } catch (e) {
      _currentUser = null;
    }
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        _authUser = response.user;
        await _loadUserProfile(response.user!.id);
        return AuthResult.success(_currentUser);
      }
      
      return AuthResult.failure('Falha ao fazer login');
    } on AuthException catch (e) {
      return AuthResult.failure(_translateAuthError(e.message));
    } catch (e) {
      return AuthResult.failure('Erro inesperado: $e');
    }
  }

  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
        },
      );

      if (response.user != null) {
        _authUser = response.user;
        
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'name': name,
          'phone': phone,
          'role': 'customer',
          'created_at': DateTime.now().toIso8601String(),
        });

        await _loadUserProfile(response.user!.id);
        return AuthResult.success(_currentUser);
      }

      return AuthResult.failure('Falha ao criar conta');
    } on AuthException catch (e) {
      return AuthResult.failure(_translateAuthError(e.message));
    } catch (e) {
      return AuthResult.failure('Erro inesperado: $e');
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final response = await _auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.studioleticia://login-callback',
      );

      if (response) {
        await initialize();
        return AuthResult.success(_currentUser);
      }

      return AuthResult.failure('Falha ao fazer login com Google');
    } on AuthException catch (e) {
      return AuthResult.failure(_translateAuthError(e.message));
    } catch (e) {
      return AuthResult.failure('Erro inesperado: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _authUser = null;
    _currentUser = null;
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  Future<AuthResult> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      if (_authUser == null) {
        return AuthResult.failure('Usuário não autenticado');
      }

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('users')
          .update(updates)
          .eq('id', _authUser!.id);

      await _loadUserProfile(_authUser!.id);
      return AuthResult.success(_currentUser);
    } catch (e) {
      return AuthResult.failure('Erro ao atualizar perfil: $e');
    }
  }

  String _translateAuthError(String error) {
    final errors = {
      'Invalid login credentials': 'Email ou senha inválidos',
      'User already registered': 'Este email já está cadastrado',
      'Password should be at least 6 characters': 'Senha deve ter pelo menos 6 caracteres',
      'Unable to validate email address: invalid format': 'Email inválido',
      'Email not confirmed': 'Email não confirmado. Verifique sua caixa de entrada.',
    };
    
    return errors[error] ?? error;
  }
}

class AuthResult {
  final bool isSuccess;
  final AppUser? user;
  final String? error;

  AuthResult._({required this.isSuccess, this.user, this.error});

  factory AuthResult.success(AppUser? user) => AuthResult._(
    isSuccess: true,
    user: user,
  );

  factory AuthResult.failure(String error) => AuthResult._(
    isSuccess: false,
    error: error,
  );
}
