import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword1 = false;
  bool _showPassword2 = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _dangKy() {
    // TODO: Implement registration logic
    Navigator.pop(context);
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
                    onLongPress: () {
                      setState(() {
                        _showPassword1 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        _showPassword1 = false;
                      });
                    },
                    child: Icon(
                      Icons.remove_red_eye,
                      size: 30.0,
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
                    onLongPress: () {
                      setState(() {
                        _showPassword2 = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      setState(() {
                        _showPassword2 = false;
                      });
                    },
                    child: Icon(
                      Icons.remove_red_eye,
                      size: 30.0,
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
                onPressed: _dangKy,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Đăng ký'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
