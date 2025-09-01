class UserModel {
  final int id;
  final String name;
  final String phone;
  final String token;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.token,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'token': token,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String status;
  final String message;
  final UserModel? user;

  AuthResponse({required this.status, required this.message, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      user: json['data'] != null && json['data']['user'] != null
          ? UserModel.fromJson(json['data']['user'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isSuccess => status == 'success';
}
