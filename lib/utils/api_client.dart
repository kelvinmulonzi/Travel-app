// lib/utils/api_client.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Booking.dart';
import '../models/Payment.dart';
import '../models/UserAuth.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.254.95:8080';
  static const String tokenKey = 'auth_token';

  final http.Client _client = http.Client();
  final Dio dio = Dio();

  // Auth endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String destinationurl = '/api/destinations/all';
  static const String destinationById = '/api/destinations/';
  static const String bookingEndpoint = '/api/bookings/';
  static const String bookingById = '/api/bookings/';
  static const String paymentEndpoint = '/api/payments/initiate';
  static const String otpverification = '/api/auth/verifyotp';


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
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        '$baseUrl$otpverification',
        data: {
          'email': email,
          'otp': otp
        },
        options: Options(
          headers: await _getHeaders(requiresAuth: false),
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          // Check for token if present
          if (responseData['token'] != null) {
            await saveToken(responseData['token']);
          }
          // Return true if success field is true or if status is 200
          return responseData['success'] ?? true;
        }
        return true; // Fallback for simple 200 response
      }
      return false;
    } on DioException catch (e) {
      print('Error verifying OTP: ${e.response?.data}');
      if (e.response?.statusCode == 400) {
        throw ApiException(
          statusCode: 400,
          message: e.response?.data['message'] ?? 'Invalid OTP',
        );
      }
      throw ApiException(
        statusCode: e.response?.statusCode ?? 500,
        message: 'Failed to verify OTP',
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
      // Make the POST request with headers and data
      final response = await dio.post(
        "$baseUrl$bookingEndpoint",
        data: bookingData,
        options: Options(headers: await _getHeaders()), // Include authorization headers if required
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        print("Booking created successfully: ${response.data}");
        // Make sure response.data is the expected type, Map<String, dynamic>
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception("Unexpected response format: ${response.data}");
        }
      } else {
        throw Exception("Failed to create booking: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Error from createBooking: $e");
      // Optional: You could throw a more specific error here for clarity
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