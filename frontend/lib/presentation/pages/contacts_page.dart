import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> _filteredContacts = [];

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
    _loadContacts();
  }

  void _loadContacts() {
    _contacts = List.from(AppConstants.sampleContacts);
    _filteredContacts = List.from(_contacts);
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = List.from(_contacts);
      } else {
        _filteredContacts = _contacts
            .where(
              (contact) =>
                  contact['name'].toLowerCase().contains(query.toLowerCase()) ||
                  contact['phone'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
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
        _filterContacts(''); // Reset filter when closing search
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
                                _filterContacts(value);
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
              child: _filteredContacts.isEmpty
                  ? _buildEmptyState()
                  : _buildContactsList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView.separated(
      itemCount: _filteredContacts.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.shade100,
        indent: 72, // Align with contact content
      ),
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        return _buildContactItem(contact);
      },
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        child: Text(
          contact['avatar'],
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        contact['name'],
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        contact['phone'],
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
      trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: contact['status'] == 'online'
              ? Colors.green
              : Colors.grey.shade400,
        ),
      ),
      onTap: () => _onContactTap(contact),
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
                : Icons.contacts_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'Không tìm thấy liên hệ'
                : 'Chưa có liên hệ nào',
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
                : 'Thêm liên hệ để bắt đầu',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _onContactTap(Map<String, dynamic> contact) {
    // Nếu thanh tìm kiếm đang mở và trống, đóng thanh tìm kiếm trước
    if (_isSearchExpanded && _searchController.text.isEmpty) {
      _toggleSearch();
      return;
    }

    // Lưu trạng thái search hiện tại
    final wasSearchExpanded = _isSearchExpanded;
    final searchText = _searchController.text;

    // Nếu có text trong search, đóng search trước khi thực hiện action
    if (_isSearchExpanded) {
      setState(() {
        _isSearchExpanded = false;
        _animationController.reverse();
        FocusScope.of(context).unfocus();
        // Không clear text để giữ lại sau khi quay về
      });

      // Delay một chút để animation hoàn thành
      Future.delayed(const Duration(milliseconds: 300), () {
        _showContactAction(contact).then((_) {
          // Khi quay lại, khôi phục trạng thái search
          if (wasSearchExpanded && searchText.isNotEmpty) {
            setState(() {
              _isSearchExpanded = true;
              _animationController.forward();
              // Text đã được giữ lại trong controller
              _filterContacts(searchText);
            });
          }
        });
      });
    } else {
      // Nếu search không mở, thực hiện action bình thường
      _showContactAction(contact);
    }
  }

  Future<void> _showContactAction(Map<String, dynamic> contact) async {
    // TODO: Navigate to chat with this contact or show contact options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mở chat với ${contact['name']}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
