// lib/utils/api_client.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Booking.dart';
import '../models/Payment.dart';
import '../models/UserAuth.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.88.248:8080';
  static const String tokenKey = 'auth_token';

  final http.Client _client = http.Client();
  final Dio dio = Dio();

  // Auth endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String destinationurl = '/api/destinations/all';
  static const String destinationById = '/api/destinations/';
  static const String bookingEndpoint = '/api/bookings';
  static const String bookingById = '/api/bookings/';
  static const String paymentEndpoint = '/api/payments/initiate';


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
        headers['Bearer'] = token;
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

  Future<Map<String, dynamic>> makePayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await dio.post(
        "$baseUrl$paymentEndpoint",
        data: paymentData,
        options: Options(headers: await _getHeaders()), // Include authorization headers if required
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Payment successful: ${response.data}");
        return response.data;
      } else {
        throw Exception("Failed to process payment: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Error from makePayment: $e");
      rethrow;
    }
  }


  // Product methods
  Future<List<dynamic>> getProducts() async {
    try {
      // Add the headers to the request
      final response = await dio.get(
        "$baseUrl$destinationurl",
        options: Options(headers: await _getHeaders()), // Add this line
      );
      if (response.statusCode == 200) {
        print("this is data from getProducts ${response.data}");
        return response.data["data"];
      } else {
        throw Exception("Failed to load products: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Error from getProducts $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProductsById(String id) async {
    try {
      final response = await dio.get("$baseUrl$destinationById$id");
      if (response.statusCode == 200) {
        print(response.data);
        return response.data["data"];
      } else {
        throw Exception("Failed to load product by ID: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Error from getProductsById $e");
      rethrow;
    }
  }

  // Booking methods
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await dio.post("$baseUrl$bookingEndpoint", data: bookingData);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        throw Exception("Failed to create booking: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Error from createBooking $e");
      rethrow;
    }
  }

  Future<List> getUserBookings(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl$bookingById/user/$userId'),
        headers: await _getHeaders(),
      );

      _handleError(response);

      final ApiResponse<List<dynamic>> apiResponse = ApiResponse.fromJson(
        json.decode(response.body),
            (json) => (json as List).cast<Map<String, dynamic>>(),
      );

      if (apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw ApiException(
          statusCode: apiResponse.status,
          message: apiResponse.message,
          error: apiResponse.error,
        );
      }
    } catch (e) {
      print("Error from getUserBookings: $e");
      rethrow;
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