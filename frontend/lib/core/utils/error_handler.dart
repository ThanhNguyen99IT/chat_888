import 'dart:io';
import 'package:flutter/material.dart';

class ErrorHandler {
  // Xử lý lỗi API chung
  static String handleApiError(dynamic error) {
    if (error is SocketException) {
      return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
    } else if (error is HttpException) {
      return 'Lỗi HTTP. Vui lòng thử lại sau.';
    } else if (error is FormatException) {
      return 'Lỗi định dạng dữ liệu từ máy chủ.';
    } else {
      return 'Đã xảy ra lỗi: ${error.toString()}';
    }
  }

  // Hiển thị thông báo lỗi
  static void showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Hiển thị thông báo thành công
  static void showSuccessSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Hiển thị thông báo thông tin
  static void showInfoSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
