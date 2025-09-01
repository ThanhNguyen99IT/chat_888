import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '888',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
