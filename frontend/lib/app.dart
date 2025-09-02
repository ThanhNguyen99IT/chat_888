import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/pages/login_page.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '888',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.authTokenKey);

      if (mounted) {
        setState(() {
          _isLoggedIn = token != null && token.isNotEmpty;
          _isLoading = false;
        });

        if (_isLoggedIn) {
          print('✅ Token found, user is logged in');
        } else {
          print('⚠️ No token found, user needs to login');
        }
      }
    } catch (e) {
      print('❌ Error checking auth status: $e');
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Hiển thị màn hình loading đơn giản trong khi kiểm tra token
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Trả về màn hình phù hợp dựa trên trạng thái đăng nhập
    return _isLoggedIn ? const MainPage() : const LoginPage();
  }
}
