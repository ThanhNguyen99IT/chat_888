class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String apiAuthPath = '/api/auth';
  static const Duration requestTimeout = Duration(seconds: 10);

  // SharedPreferences Keys
  static const String authTokenKey = 'auth_token';

  // UI Constants
  static const double borderRadius = 8.0;
  static const double appBarBorderRadius = 25.0;
  static const double avatarSize = 80.0;
  static const double buttonHeight = 48.0;

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration searchAnimationDuration = Duration(milliseconds: 300);

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/webp',
    'image/bmp',
  ];

  // Sample Data - can be moved to separate file later
  static const List<Map<String, dynamic>> samplePosts = [
    {
      'author': 'Nguyen Van A',
      'content': 'Chào mừng đến với ứng dụng chat 888! 🎉',
      'time': '2 giờ trước',
      'likes': 5,
      'comments': 3,
    },
    {
      'author': 'Tran Thi B',
      'content': 'Ứng dụng rất tiện lợi và dễ sử dụng 👍',
      'time': '5 giờ trước',
      'likes': 8,
      'comments': 2,
    },
    {
      'author': 'Le Van C',
      'content': 'Tính năng nhắn tin rất nhanh và ổn định',
      'time': '1 ngày trước',
      'likes': 12,
      'comments': 7,
    },
  ];

  static const List<Map<String, dynamic>> sampleContacts = [
    {
      'name': 'Nguyen Van A',
      'phone': '0912345678',
      'avatar': 'A',
      'status': 'online',
      'lastMessage': 'Chào bạn!',
      'time': '10:30',
    },
    {
      'name': 'Tran Thi B',
      'phone': '0987654321',
      'avatar': 'B',
      'status': 'offline',
      'lastMessage': 'Hẹn gặp lại',
      'time': 'Hôm qua',
    },
    {
      'name': 'Le Van C',
      'phone': '0123456789',
      'avatar': 'C',
      'status': 'online',
      'lastMessage': 'OK, cảm ơn!',
      'time': '14:20',
    },
  ];
}
