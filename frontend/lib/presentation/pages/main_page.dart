import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_theme.dart';
import 'home_page.dart';
import 'contacts_page.dart';
import 'posts_page.dart';
import 'profile_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;
  final AnimationController? animationController;
  final int previousIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.animationController,
    required this.previousIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / items.length;
    final circleRadius = 28.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main bottom bar with notch
        if (animationController != null)
          AnimatedBuilder(
            animation: animationController!,
            builder: (context, child) {
              // Calculate animated index using lerp between previous and current index
              final animatedIndex =
                  previousIndex +
                  (currentIndex - previousIndex) *
                      Curves.easeInOut.transform(animationController!.value);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(screenWidth, 80),
                    painter: BottomBarPainter(
                      animatedIndex: animatedIndex,
                      itemCount: items.length,
                      primaryColor: AppTheme.primaryColor,
                    ),
                  ),

                  // Moving circle + selected icon in-sync with bump
                  Positioned(
                    left:
                        animatedIndex * itemWidth +
                        (itemWidth - circleRadius * 2) / 2,
                    top: 8 - 23,
                    child: Container(
                      width: circleRadius * 2,
                      height: circleRadius * 2,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: animatedIndex * itemWidth + (itemWidth - 48) / 2,
                    top: 8 - 23 + (circleRadius * 2 - 48) / 2,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Icon(
                        (items[currentIndex].icon as Icon).icon!,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        else
          CustomPaint(
            size: Size(screenWidth, 80),
            painter: BottomBarPainter(
              animatedIndex: currentIndex.toDouble(),
              itemCount: items.length,
              primaryColor: AppTheme.primaryColor,
            ),
          ),

        // Bottom bar content
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon (only show non-selected icons, selected icon is handled separately)
                      Transform.translate(
                        offset: const Offset(
                          0,
                          -8,
                        ), // Move up a bit like selected icon
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: isSelected
                              ? const SizedBox.shrink() // Hide selected icon (handled by AnimatedPositioned)
                              : Icon(
                                  (item.icon as Icon).icon!,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class BottomBarPainter extends CustomPainter {
  final double animatedIndex; // Changed from int to double for smooth animation
  final int itemCount;
  final Color primaryColor;

  BottomBarPainter({
    required this.animatedIndex,
    required this.itemCount,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();
    final shadowPath = Path();

    final itemWidth = size.width / itemCount;
    final notchCenter = animatedIndex * itemWidth + itemWidth / 2;
    // Kích thước vòng tròn khi được chọn: 56 → radius ~28 (chừa biên an toàn 2px)
    final circleRadius = 28.0;
    // Tăng độ rộng bump (nửa chiều rộng). Ví dụ 2.5x bán kính
    final notchWidth = circleRadius * 2.5;
    // Độ cao bump (px)
    final notchHeight = 22.0;

    // Create the bottom bar path with circular notch
    path.moveTo(0, 0);

    // Draw to the start of the bump
    path.lineTo(notchCenter - notchWidth, 0);

    // Smooth bump using cubic Bezier (không tạo khuyết trước bump)
    path.cubicTo(
      notchCenter - notchWidth * 0.5,
      0, // control 1
      notchCenter - notchWidth * 0.4,
      -notchHeight, // control 2
      notchCenter,
      -notchHeight, // peak
    );
    path.cubicTo(
      notchCenter + notchWidth * 0.4,
      -notchHeight, // control 1
      notchCenter + notchWidth * 0.5,
      0, // control 2
      notchCenter + notchWidth,
      0, // end
    );

    // Complete the bottom bar
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Create shadow path (slightly offset)
    shadowPath.addPath(path, const Offset(0, 2));

    // Draw shadow
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw main bottom bar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BottomBarPainter oldDelegate) {
    return oldDelegate.animatedIndex != animatedIndex;
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  AnimationController? _animationController;

  final List<Widget> _pages = [
    const HomePage(),
    const ContactsPage(),
    const PostsPage(),
    const ProfilePage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Iconsax.message),
      activeIcon: Icon(Iconsax.message),
      label: 'Nhắn tin',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Iconsax.people),
      activeIcon: Icon(Iconsax.people),
      label: 'Danh bạ',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Iconsax.document),
      activeIcon: Icon(Iconsax.document),
      label: 'Bài viết',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Iconsax.user),
      activeIcon: Icon(Iconsax.user),
      label: 'Cá nhân',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
      });

      _animationController?.reset();
      _animationController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _bottomNavItems,
        animationController: _animationController,
        previousIndex: _previousIndex,
      ),
    );
  }
}
