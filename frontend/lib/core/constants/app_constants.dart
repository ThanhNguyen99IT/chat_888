import 'dart:io';

class AppConstants {
  // API Configuration
  static String get baseUrl =>
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
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

  // Sample Conversations Data
  static List<Map<String, dynamic>> get sampleConversations => [
    {
      'id': '1',
      'name': 'Nguyen Van A',
      'avatar': null,
      'lastMessage': 'Chào bạn! Hôm nay thế nào?',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(minutes: 5))
          .toIso8601String(),
      'unreadCount': 2,
      'isOnline': true,
      'isGroup': false,
    },
    {
      'id': '2',
      'name': 'Tran Thi B',
      'avatar': null,
      'lastMessage': 'Cảm ơn bạn đã giúp đỡ! 👍',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(hours: 1))
          .toIso8601String(),
      'unreadCount': 0,
      'isOnline': false,
      'isGroup': false,
    },
    {
      'id': '3',
      'name': 'Le Van C',
      'avatar': null,
      'lastMessage': 'Hẹn gặp lại vào tuần sau nhé',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(hours: 3))
          .toIso8601String(),
      'unreadCount': 1,
      'isOnline': true,
      'isGroup': false,
    },
    {
      'id': '4',
      'name': 'Pham Thi D',
      'avatar': null,
      'lastMessage': 'Bạn có thể gửi file cho mình được không?',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(hours: 6))
          .toIso8601String(),
      'unreadCount': 0,
      'isOnline': false,
      'isGroup': false,
    },
    {
      'id': '5',
      'name': 'Hoang Van E',
      'avatar': null,
      'lastMessage': 'OK, mình sẽ check lại và báo bạn',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      'unreadCount': 3,
      'isOnline': false,
      'isGroup': false,
    },
    {
      'id': '6',
      'name': 'Nhóm Công Việc',
      'avatar': null,
      'lastMessage': 'Cuộc họp sáng mai lúc 9h nhé mọi người',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      'unreadCount': 5,
      'isOnline': false,
      'isGroup': true,
    },
    {
      'id': '7',
      'name': 'Nguyen Thi F',
      'avatar': null,
      'lastMessage': 'Cảm ơn bạn nhiều! 😊',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String(),
      'unreadCount': 0,
      'isOnline': false,
      'isGroup': false,
    },
    {
      'id': '8',
      'name': 'Nhóm Bạn Bè',
      'avatar': null,
      'lastMessage': 'Tối nay đi ăn không mọi người?',
      'lastMessageTime': DateTime.now()
          .subtract(const Duration(days: 3))
          .toIso8601String(),
      'unreadCount': 0,
      'isOnline': false,
      'isGroup': true,
    },
  ];

  // Sample Messages Data for different conversations
  static Map<String, List<Map<String, dynamic>>> get sampleMessages => {
    '1': [
      // Nguyen Van A conversation
      {
        'id': 'msg_1_1',
        'conversationId': '1',
        'senderId': 'current_user',
        'senderName': 'Bạn',
        'senderAvatar': null,
        'content': 'Chào bạn! Hôm nay thế nào?',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 10))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
      {
        'id': 'msg_1_2',
        'conversationId': '1',
        'senderId': 'user_1',
        'senderName': 'Nguyen Van A',
        'senderAvatar': null,
        'content': 'Chào bạn! Mình khỏe, cảm ơn bạn đã hỏi thăm 😊',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 8))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
      {
        'id': 'msg_1_3',
        'conversationId': '1',
        'senderId': 'current_user',
        'senderName': 'Bạn',
        'senderAvatar': null,
        'content': 'Tuyệt vời! Bạn có kế hoạch gì cho cuối tuần không?',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        'status': 'delivered',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
    ],
    '2': [
      // Tran Thi B conversation
      {
        'id': 'msg_2_1',
        'conversationId': '2',
        'senderId': 'user_2',
        'senderName': 'Tran Thi B',
        'senderAvatar': null,
        'content': 'Cảm ơn bạn đã giúp đỡ! 👍',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
    ],
    '3': [
      // Le Van C conversation
      {
        'id': 'msg_3_1',
        'conversationId': '3',
        'senderId': 'user_3',
        'senderName': 'Le Van C',
        'senderAvatar': null,
        'content': 'Hẹn gặp lại vào tuần sau nhé',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 3))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
      {
        'id': 'msg_3_2',
        'conversationId': '3',
        'senderId': 'current_user',
        'senderName': 'Bạn',
        'senderAvatar': null,
        'content': 'OK, hẹn gặp lại!',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 30))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
    ],
    '6': [
      // Nhóm Công Việc conversation
      {
        'id': 'msg_6_1',
        'conversationId': '6',
        'senderId': 'user_4',
        'senderName': 'Pham Thi D',
        'senderAvatar': null,
        'content': 'Cuộc họp sáng mai lúc 9h nhé mọi người',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
      {
        'id': 'msg_6_2',
        'conversationId': '6',
        'senderId': 'current_user',
        'senderName': 'Bạn',
        'senderAvatar': null,
        'content': 'OK, mình sẽ tham gia',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(days: 1, minutes: -30))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
      {
        'id': 'msg_6_3',
        'conversationId': '6',
        'senderId': 'user_5',
        'senderName': 'Hoang Van E',
        'senderAvatar': null,
        'content': 'Mình cũng tham gia',
        'type': 'text',
        'timestamp': DateTime.now()
            .subtract(const Duration(days: 1, minutes: -20))
            .toIso8601String(),
        'status': 'read',
        'replyToMessageId': null,
        'isEdited': false,
        'editedAt': null,
      },
    ],
  };
}
