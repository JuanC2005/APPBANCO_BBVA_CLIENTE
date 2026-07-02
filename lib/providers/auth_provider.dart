import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';
import '../core/secure_storage.dart';
import '../models/user_model.dart';
import 'api_client_provider.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiClientProvider));
});

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final UserModel? user;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    UserModel? user,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;

  AuthNotifier(this._api) : super(const AuthState());

  Future<void> login(String documento, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post('/homebanking/login', {
        'numero_documento': documento,
        'password': password,
      });
      final token = response['access_token'] as String;
      final clienteData = response['cliente'] as Map<String, dynamic>;
      await SecureStorage.saveToken(token);
      final user = UserModel.fromJson(clienteData);
      state = AuthState(isAuthenticated: true, user: user);
    } on HttpException catch (e) {
      state = state.copyWith(isLoading: false, error: 'Credenciales incorrectas ($e)');
    } on SocketException catch (e) {
      state = state.copyWith(isLoading: false, error: 'No hay conexión a internet. (${e.message})');
    } on TimeoutException catch (e) {
      state = state.copyWith(isLoading: false, error: 'El servidor tardó demasiado en responder. (${e.message})');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error inesperado: ${e.toString()}');
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post('/homebanking/registro', data);
      final token = response['access_token'] as String;
      final clienteData = response['cliente'] as Map<String, dynamic>;
      await SecureStorage.saveToken(token);
      final user = UserModel.fromJson(clienteData);
      state = AuthState(isAuthenticated: true, user: user);
    } on HttpException catch (e) {
      state = state.copyWith(isLoading: false, error: 'El número de documento ya está registrado ($e)');
    } on SocketException catch (e) {
      state = state.copyWith(isLoading: false, error: 'No hay conexión a internet. (${e.message})');
    } on TimeoutException catch (e) {
      state = state.copyWith(isLoading: false, error: 'El servidor tardó demasiado en responder. (${e.message})');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error inesperado: ${e.toString()}');
    }
  }

  Future<void> checkSession() async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      try {
        final response = await _api.get('/homebanking/perfil');
        final user = UserModel.fromJson(response);
        state = AuthState(isAuthenticated: true, user: user);
        return;
      } catch (_) {}
    }
    state = const AuthState();
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    state = const AuthState();
  }
}
