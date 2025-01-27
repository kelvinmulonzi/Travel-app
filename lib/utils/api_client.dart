// lib/utils/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserAuth.dart';

class ApiClient {
  static const String baseUrl = 'https://fc40-41-220-228-218.ngrok-free.app';  // Replace with your actual API URL
  static const String tokenKey = 'auth_token';

  final http.Client _client = http.Client();

  // Auth endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';

  // Token management
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Headers with authentication
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Generic error handler
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      final ApiResponse<dynamic> apiResponse = ApiResponse.fromJson(
        json.decode(response.body),
            (json) => json,
      );
      throw ApiException(
        statusCode: response.statusCode,
        message: apiResponse.message,
        error: apiResponse.error,
      );
    }
  }

  // Auth methods
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$loginEndpoint'),
      headers: await _getHeaders(requiresAuth: false),
      body: json.encode(request.toJson()),
    );

    _handleError(response);

    final ApiResponse<AuthResponse> apiResponse = ApiResponse.fromJson(
      json.decode(response.body),
          (json) => AuthResponse.fromJson(json),
    );

    if (apiResponse.data != null) {
      await saveToken(apiResponse.data!.token);
      return apiResponse.data!;
    } else {
      throw ApiException(
        statusCode: apiResponse.status,
        message: apiResponse.message,
        error: apiResponse.error,
      );
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$registerEndpoint'),
      headers: await _getHeaders(requiresAuth: false),
      body: json.encode(request.toJson()),
    );

    _handleError(response);

    final ApiResponse<AuthResponse> apiResponse = ApiResponse.fromJson(
      json.decode(response.body),
          (json) => AuthResponse.fromJson(json),
    );

    if (apiResponse.data != null) {
      await saveToken(apiResponse.data!.token);
      return apiResponse.data!;
    } else {
      throw ApiException(
        statusCode: apiResponse.status,
        message: apiResponse.message,
        error: apiResponse.error,
      );
    }
  }
}

// Custom exception
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? error;

  ApiException({
    required this.statusCode,
    required this.message,
    this.error,
  });

  @override
  String toString() => 'ApiException: $message${error != null ? ' ($error)' : ''}';
}