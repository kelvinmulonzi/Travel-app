// lib/services/auth_service.dart

import 'package:dio/dio.dart';

import '../models/UserAuth.dart';
import '../utils/api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AuthResponse> login(String username, String password) async {
    final request = LoginRequest(
      username: username,
      password: password,
    );
    return _apiClient.login(request);
  }

  Future<Response> register(String username, String password, String email) async {
    final request = RegisterRequest(
      username: username,
      password: password,
      email: email,
    );
    return _apiClient.register(request);
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _apiClient.getToken();
    return token != null;
  }
}