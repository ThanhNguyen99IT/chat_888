import 'package:flutter/material.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../presentation/pages/home_page.dart';
import '../core/theme/app_theme.dart';
import '../data/datasources/auth_api.dart';
import '../data/models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isQuenMatKhauPressed = false;
  bool _isTaoTaiKhoanPressed = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthApi.login(
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (response.isSuccess && response.user != null) {
        // Đăng nhập thành công, chuyển đến trang chủ
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        _showMessage(response.message);
      }
    } catch (e) {
      _showMessage('Đã xảy ra lỗi: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('thành công')
              ? Colors.green
              : Colors.red,
        ),
      );
    }
  }

  void _onQuenMatKhauTap() {
    setState(() {
      _isQuenMatKhauPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isQuenMatKhauPressed = false;
        });
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  void _onTaoTaiKhoanTap() {
    setState(() {
      _isTaoTaiKhoanPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isTaoTaiKhoanPressed = false;
        });
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: "Số điện thoại",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    hintStyle: TextStyle(color: Color(0xffCCCCCC)),
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: const InputDecoration(
                        hintText: "Mật khẩu",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        hintStyle: TextStyle(color: Color(0xffCCCCCC)),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _showPassword = true;
                          });
                        },
                        onLongPressEnd: (details) {
                          setState(() {
                            _showPassword = false;
                          });
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 30.0,
                          color: _showPassword
                              ? AppTheme.primaryColor
                              : const Color(0xffCCCCCC),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Đăng nhập'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 18,
            bottom: 12,
            child: GestureDetector(
              onTap: _onQuenMatKhauTap,
              child: Text(
                "Quên mật khẩu?",
                style: TextStyle(
                  color: _isQuenMatKhauPressed
                      ? AppTheme.primaryColor
                      : Colors.black54,
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 12,
            child: GestureDetector(
              onTap: _onTaoTaiKhoanTap,
              child: Text(
                "Tạo tài khoản",
                style: TextStyle(
                  color: _isTaoTaiKhoanPressed
                      ? AppTheme.primaryColor
                      : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
