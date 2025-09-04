import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/conversation.dart';
import '../widgets/conversation_item.dart';
import 'chat_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  List<Conversation> _conversations = [];
  List<Conversation> _filteredConversations = [];
  bool _isQrPressed = false;
  bool _isAddPressed = false;
  Timer? _qrTimer;
  Timer? _addTimer;
  DateTime? _lastQrClick;
  DateTime? _lastAddClick;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.searchAnimationDuration,
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 40.0, end: 300.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadConversations();
  }

  void _loadConversations() {
    // Load sample conversations
    _conversations = AppConstants.sampleConversations
        .map((data) => Conversation.fromJson(data))
        .toList();

    // Sort by last message time (newest first)
    _conversations.sort(
      (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
    );

    _filteredConversations = List.from(_conversations);
  }

  void _filterConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = List.from(_conversations);
      } else {
        _filteredConversations = _conversations
            .where(
              (conversation) =>
                  conversation.name.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  conversation.lastMessage.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _qrTimer?.cancel();
    _addTimer?.cancel();
    super.dispose();
  }

  void _handleButtonPress(bool isQrButton) {
    final now = DateTime.now();

    // Debounce: ignore clicks within 200ms
    if (isQrButton) {
      if (_lastQrClick != null &&
          now.difference(_lastQrClick!).inMilliseconds < 200) {
        return;
      }
      _lastQrClick = now;

      _qrTimer?.cancel();
      if (mounted) {
        setState(() => _isQrPressed = true);
      }

      _qrTimer = Timer(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() => _isQrPressed = false);
        }
      });
    } else {
      if (_lastAddClick != null &&
          now.difference(_lastAddClick!).inMilliseconds < 200) {
        return;
      }
      _lastAddClick = now;

      _addTimer?.cancel();
      if (mounted) {
        setState(() => _isAddPressed = true);
      }

      _addTimer = Timer(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() => _isAddPressed = false);
        }
      });
    }
  }

  Widget _buildCustomButton({
    required bool isPressed,
    required VoidCallback onPressed,
    required String tooltip,
    required Widget child,
    bool isSvg = false,
  }) {
    final color = isPressed ? AppTheme.primaryColor : Colors.grey.shade500;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 1),
        ),
        child: Center(
          child: isSvg
              ? SvgPicture.asset(
                  'assets/images/user-plus.svg',
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                )
              : IconTheme(
                  data: IconThemeData(color: color),
                  child: child,
                ),
        ),
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide search bar if empty when tapping outside (but not on AppBar)
        if (_isSearchExpanded && _searchController.text.isEmpty) {
          _toggleSearch();
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
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
          title: GestureDetector(
            onTap: () {
              // Open search when tapping on title area
              if (!_isSearchExpanded) {
                _toggleSearch();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 40,
              child: Stack(
                children: [
                  // Search bar that slides out
                  if (_isSearchExpanded)
                    AnimatedBuilder(
                      animation: _widthAnimation,
                      builder: (context, child) {
                        return Center(
                          child: Container(
                            height: 40,
                            width: _widthAnimation.value,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              textAlignVertical: TextAlignVertical.center,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                _filterConversations(value);
                              },
                              onSubmitted: (value) {
                                // TODO: Handle search submission
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tìm kiếm: $value'),
                                    backgroundColor: const Color(0xFF7B91FF),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            // Search icon that stays in place
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isSearchExpanded ? Icons.close : Icons.search,
                  key: ValueKey(_isSearchExpanded),
                ),
              ),
              onPressed: _toggleSearch,
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
              child: _filteredConversations.isEmpty
                  ? _buildEmptyState()
                  : _buildConversationList(),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildCustomButton(
                isPressed: _isQrPressed,
                onPressed: () => _handleButtonPress(true),
                tooltip: 'Quét mã',
                child: const Icon(Icons.qr_code_scanner, size: 24),
              ),
              const SizedBox(height: 12),
              _buildCustomButton(
                isPressed: _isAddPressed,
                onPressed: () => _handleButtonPress(false),
                tooltip: 'Thêm bạn',
                child:
                    const SizedBox(), // Placeholder, not used when isSvg=true
                isSvg: true,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildConversationList() {
    return ListView.separated(
      itemCount: _filteredConversations.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade100, indent: 76),
      itemBuilder: (context, index) {
        final conversation = _filteredConversations[index];
        return ConversationItem(
          conversation: conversation,
          onTap: () => _onConversationTap(conversation),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchController.text.isNotEmpty
                ? Icons.search_off
                : Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'Không tìm thấy cuộc trò chuyện'
                : 'Chưa có cuộc trò chuyện nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Bắt đầu cuộc trò chuyện đầu tiên',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _onConversationTap(Conversation conversation) {
    // Nếu thanh tìm kiếm đang mở và trống, đóng thanh tìm kiếm trước
    if (_isSearchExpanded && _searchController.text.isEmpty) {
      _toggleSearch();
      return;
    }

    // Lưu trạng thái search hiện tại
    final wasSearchExpanded = _isSearchExpanded;
    final searchText = _searchController.text;

    // Nếu có text trong search, đóng search trước khi navigate nhưng giữ text
    if (_isSearchExpanded) {
      setState(() {
        _isSearchExpanded = false;
        _animationController.reverse();
        FocusScope.of(context).unfocus();
        // Không clear text để giữ lại sau khi quay về
      });

      // Delay một chút để animation hoàn thành
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversation: conversation),
          ),
        ).then((_) {
          // Khi quay lại từ ChatScreen, khôi phục trạng thái search
          if (wasSearchExpanded && searchText.isNotEmpty) {
            setState(() {
              _isSearchExpanded = true;
              _animationController.forward();
              // Text đã được giữ lại trong controller
              _filterConversations(searchText);
            });
          }
        });
      });
    } else {
      // Nếu search không mở, navigate bình thường
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(conversation: conversation),
        ),
      );
    }
  }
}
