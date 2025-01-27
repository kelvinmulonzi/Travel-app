// lib/models/auth_models.dart

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

class RegisterRequest {
  final String username;
  final String password;
  final String email;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'email': email,
  };
}

class AuthResponse {
  final String token;
  final String username;
  final String message;

  AuthResponse({
    required this.token,
    required this.username,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      username: json['username'],
      message: json['message'],
    );
  }
}

class ApiResponse<T> {
  final int status;
  final String message;
  final T? data;
  final DateTime timestamp;
  final String? error;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
    this.error,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: DateTime.parse(json['timestamp']),
      error: json['error'],
    );
  }
}