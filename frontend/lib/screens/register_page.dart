import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/datasources/auth_api.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword1 = false;
  bool _showPassword2 = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showMessage('Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('Mật khẩu xác nhận không khớp');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showMessage('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthApi.register(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (response.isSuccess && response.user != null) {
        _showMessage('Đăng ký thành công!');
        // Chuyển về trang đăng nhập sau 1 giây
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        leading: BackButton(color: AppTheme.primaryColor),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Họ và tên",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                hintStyle: TextStyle(color: Color(0xffCCCCCC)),
              ),
            ),
            const SizedBox(height: 10),
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
                  obscureText: !_showPassword1,
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
                    onTap: () {
                      setState(() {
                        _showPassword1 = !_showPassword1;
                      });
                    },
                    child: Icon(
                      _showPassword1 ? Icons.visibility_off : Icons.visibility,
                      size: 24.0,
                      color: _showPassword1
                          ? AppTheme.primaryColor
                          : const Color(0xffCCCCCC),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_showPassword2,
                  decoration: const InputDecoration(
                    hintText: "Nhập lại mật khẩu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    hintStyle: TextStyle(color: Color(0xffCCCCCC)),
                  ),
                ),
                Positioned(
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPassword2 = !_showPassword2;
                      });
                    },
                    child: Icon(
                      _showPassword2 ? Icons.visibility_off : Icons.visibility,
                      size: 24.0,
                      color: _showPassword2
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
                onPressed: _isLoading ? null : _handleRegister,
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
                    : const Text('Đăng ký'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
