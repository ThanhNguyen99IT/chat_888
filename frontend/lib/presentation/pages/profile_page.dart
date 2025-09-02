import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import 'login_page.dart';
import '../../data/datasources/auth_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _userProfile = {
    'name': 'Đang tải...',
    'phone': 'Đang tải...',
    'email': 'Đang tải...',
    'avatar': '?',
    'status': 'online',
  };

  String? _avatarImagePath;
  bool _isLoading = true;
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Lấy token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _userToken = prefs.getString(AppConstants.authTokenKey);

      if (_userToken == null || _userToken!.isEmpty) {
        print('⚠️ No token found, redirecting to login');
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
        return;
      }

      print('🔑 Using token: $_userToken');

      const String baseUrl = AppConstants.baseUrl;
      final uri = Uri.parse('$baseUrl${AppConstants.apiAuthPath}/profile');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'token': _userToken!},
      );

      print('📊 Profile response status: ${response.statusCode}');
      print('📄 Profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final userData = jsonResponse['data']['user'];

          setState(() {
            _userProfile = {
              'name': userData['name'] ?? 'Test User',
              'phone': userData['phone'] ?? '0123456789',
              'email':
                  'testuser@example.com', // Có thể thêm email vào database sau
              'avatar': userData['name']?.substring(0, 1)?.toUpperCase() ?? 'T',
              'status': 'online',
            };

            // Nếu có image_url, hiển thị ảnh từ server
            if (userData['image_url'] != null) {
              _avatarImagePath = '$baseUrl${userData['image_url']}';
            }

            _isLoading = false;
          });

          print('✅ User profile loaded: ${_userProfile['name']}');
        } else {
          throw Exception(jsonResponse['message'] ?? 'Lỗi tải thông tin');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Load profile error: $e');
      setState(() {
        _userProfile = {
          'name': 'Lỗi tải dữ liệu',
          'phone': 'Lỗi tải dữ liệu',
          'email': 'Lỗi tải dữ liệu',
          'avatar': '!',
          'status': 'offline',
        };
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tải thông tin: $e')));
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    // Xóa token
    await AuthApi.logout();

    // Chuyển về trang đăng nhập
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2048,
      );
      if (picked == null) return;

      // Hiển thị loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // Upload ảnh lên server
      await _uploadImageToServer(picked.path);

      if (mounted) {
        Navigator.pop(context); // Đóng loading
        Navigator.pop(context); // Đóng bottom sheet
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Đóng loading nếu có
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không thể chọn ảnh: $e')));
      }
    }
  }

  Future<void> _uploadImageToServer(String imagePath) async {
    try {
      // Đảm bảo có token
      if (_userToken == null || _userToken!.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        _userToken = prefs.getString(AppConstants.authTokenKey);

        if (_userToken == null || _userToken!.isEmpty) {
          throw Exception('Chưa đăng nhập. Vui lòng đăng nhập lại.');
        }
      }

      const String baseUrl = AppConstants.baseUrl;
      final uri = Uri.parse(
        '$baseUrl${AppConstants.apiAuthPath}/upload-avatar',
      );

      var request = http.MultipartRequest('POST', uri);
      request.headers['token'] = _userToken!;
      request.headers['Content-Type'] = 'multipart/form-data';

      // Thêm file ảnh với đúng field name và content type
      final file = await http.MultipartFile.fromPath('avatar', imagePath);

      // Log file info để debug
      print('📁 File name: ${file.filename}');
      print('📄 Content type: ${file.contentType}');
      print('📊 File length: ${file.length}');

      request.files.add(file);

      print('🚀 Uploading to: $uri');
      print('📁 File path: $imagePath');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response data: $responseData');

      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        // Reload profile để lấy thông tin mới từ server
        await _loadUserProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật ảnh đại diện thành công!')),
          );
        }
      } else {
        throw Exception(jsonResponse['message'] ?? 'Upload failed');
      }
    } catch (e) {
      print('❌ Upload error: $e');
      throw Exception('Lỗi upload ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          title: const Text('Cá nhân'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          color: AppTheme.primaryColor,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Open drawer or menu
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mở menu'),
                backgroundColor: Color(0xFF7B91FF),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () {
              // TODO: Open settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mở cài đặt'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF7B91FF)),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Avatar with edit overlay (only UI change)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipOval(
                              child: Container(
                                width: 80,
                                height: 80,
                                color: AppTheme.primaryColor,
                                child: _avatarImagePath != null
                                    ? (_avatarImagePath!.startsWith('http')
                                          ? Image.network(
                                              _avatarImagePath!,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    print(
                                                      '❌ Error loading network image: $error',
                                                    );
                                                    return Center(
                                                      child: Text(
                                                        _userProfile['avatar'],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Image.file(
                                              File(_avatarImagePath!),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ))
                                    : Center(
                                        child: Text(
                                          _userProfile['avatar'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                color: Colors.white,
                                shape: const CircleBorder(),
                                elevation: 1,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: _showAvatarOptions,
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Iconsax.edit_25,
                                      size: 18,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userProfile['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userProfile['phone'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Online',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Menu Items
                  _buildMenuItem(
                    icon: Iconsax.user_edit,
                    title: 'Chỉnh sửa thông tin',
                    onTap: () {
                      // TODO: Edit profile
                    },
                  ),
                  _buildMenuItem(
                    icon: Iconsax.notification,
                    title: 'Thông báo',
                    onTap: () {
                      // TODO: Notification settings
                    },
                  ),
                  _buildMenuItem(
                    icon: Iconsax.shield_tick,
                    title: 'Bảo mật',
                    onTap: () {
                      // TODO: Security settings
                    },
                  ),
                  _buildMenuItem(
                    icon: Iconsax.message_question,
                    title: 'Trợ giúp',
                    onTap: () {
                      // TODO: Help center
                    },
                  ),
                  _buildMenuItem(
                    icon: Iconsax.info_circle,
                    title: 'Về ứng dụng',
                    onTap: () {
                      // TODO: About app
                    },
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Iconsax.logout),
                      label: const Text('Đăng xuất'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cập nhật ảnh đại diện',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _AvatarActionButton(
                            imageAsset: 'assets/images/add_image.png',
                            onTap: _pickFromGallery,
                          ),
                          const SizedBox(width: 24),
                          _AvatarActionButton(
                            imageAsset: 'assets/images/camera.png',
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tính năng sẽ bổ sung sau'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Iconsax.arrow_right_3),
      onTap: onTap,
    );
  }
}

class _AvatarActionButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final String? imageAsset;

  const _AvatarActionButton({
    super.key,
    this.icon,
    this.label,
    required this.onTap,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: (imageAsset != null)
            ? Image.asset(imageAsset!, width: 60, height: 60)
            : (icon != null)
            ? Icon(icon, size: 60, color: AppTheme.primaryColor)
            : const SizedBox.shrink(),
      ),
    );
  }
}
