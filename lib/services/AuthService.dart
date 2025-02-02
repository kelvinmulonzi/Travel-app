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

  Future<AuthResponse> register(String username, String password, String email, String otp) async {
    final request = RegisterRequest(
      username: username,
      password: password,
      email: email,
      otp: otp,
    );
    return _apiClient.register(request);
  }

  // Add new method for OTP verification
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      return await _apiClient.verifyOtp(email, otp);
    } catch (e) {
      rethrow; // Propagate the error to be handled by the UI
    }
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _apiClient.getToken();
    return token != null;
  }
}