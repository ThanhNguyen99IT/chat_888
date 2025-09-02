import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class AuthApi {
  static const String baseUrl =
      '${AppConstants.baseUrl}${AppConstants.apiAuthPath}';

  // Timeout cho các request
  static const Duration timeout = AppConstants.requestTimeout;

  // Đăng ký
  static Future<AuthResponse> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'phone': phone,
              'password': password,
            }),
          )
          .timeout(timeout);

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(responseData);
    } on SocketException {
      return AuthResponse(
        status: 'error',
        message:
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
      );
    } on HttpException {
      return AuthResponse(
        status: 'error',
        message: 'Lỗi HTTP. Vui lòng thử lại sau.',
      );
    } on FormatException {
      return AuthResponse(
        status: 'error',
        message: 'Lỗi định dạng dữ liệu từ máy chủ.',
      );
    } catch (e) {
      return AuthResponse(
        status: 'error',
        message: 'Đã xảy ra lỗi: ${e.toString()}',
      );
    }
  }

  // Đăng nhập
  static Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': phone, 'password': password}),
          )
          .timeout(timeout);

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(responseData);

      // Lưu token vào SharedPreferences nếu đăng nhập thành công
      if (authResponse.isSuccess && authResponse.user?.token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          AppConstants.authTokenKey,
          authResponse.user!.token!,
        );
        print('✅ Token saved: ${authResponse.user!.token}');
      }

      return authResponse;
    } on SocketException {
      return AuthResponse(
        status: 'error',
        message:
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
      );
    } on HttpException {
      return AuthResponse(
        status: 'error',
        message: 'Lỗi HTTP. Vui lòng thử lại sau.',
      );
    } on FormatException {
      return AuthResponse(
        status: 'error',
        message: 'Lỗi định dạng dữ liệu từ máy chủ.',
      );
    } catch (e) {
      return AuthResponse(
        status: 'error',
        message: 'Đã xảy ra lỗi: ${e.toString()}',
      );
    }
  }

  // Lấy thông tin profile
  static Future<AuthResponse> getProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/profile'),
            headers: {'Content-Type': 'application/json', 'token': token},
          )
          .timeout(timeout);

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(responseData);
    } on SocketException {
      return AuthResponse(
        status: 'error',
        message:
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
      );
    } on HttpException {
      return AuthResponse(
        status: 'error',
        message: 'Lỗi HTTP. Vui lòng thử lại sau.',
      );
    } on FormatException {
      return AuthResponse(
        status: 'error',
        message: 'Lỗi định dạng dữ liệu từ máy chủ.',
      );
    } catch (e) {
      return AuthResponse(
        status: 'error',
        message: 'Đã xảy ra lỗi: ${e.toString()}',
      );
    }
  }

  // Đăng xuất
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.authTokenKey);
      print('✅ Token removed - user logged out');
    } catch (e) {
      print('❌ Error during logout: $e');
    }
  }
}
