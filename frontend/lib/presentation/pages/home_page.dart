import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 40.0, end: 300.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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
                                  vertical: 8,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                // TODO: Implement search functionality
                                print('Search: $value');
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
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Color(0xFF7B91FF),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome to 888',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B91FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
