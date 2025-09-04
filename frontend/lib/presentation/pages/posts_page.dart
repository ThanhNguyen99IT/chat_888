import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _posts = AppConstants.samplePosts;
  late TabController _tabController;
  int _currentTabIndex = 1;
  int _previousTabIndex = 1;
  bool _isVideoMode = false; // false = bài viết (mặc định), true = video

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(_onTabChanged);
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildPostsList('Bạn bè'),
        _buildPostsList('Cộng đồng'),
        _buildPostsList('Theo dõi'),
      ],
    );
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _previousTabIndex = _currentTabIndex;
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorWeight: 3.0,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.3,
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white.withOpacity(0.1);
            }
            return null;
          }),
          splashFactory: InkRipple.splashFactory,
          tabs: const [
            Tab(
              child: Text(
                'Bạn bè',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Tab(
              child: Text(
                'Cộng đồng',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Tab(
              child: Text(
                'Theo dõi',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.video_play),
          onPressed: () {
            // TODO: Watch live streams
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Xem live'),
                backgroundColor: Color(0xFF7B91FF),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search posts
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tìm kiếm bài viết'),
                  backgroundColor: Color(0xFF7B91FF),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xFF7B91FF)),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: Container(color: Colors.white, child: _buildTabContent()),
            ),
          ),
          // Floating Action Button
          Positioned(right: 8, bottom: 20, child: _buildFloatingActionButton()),
          // Icon chia sẻ (animated)
          _buildAnimatedAction(
            child: _buildActionIcon(Iconsax.send_2, 'Chia sẻ'),
            shownBottom: 95,
            index: 0,
          ),
          // Icon lưu (animated)
          _buildAnimatedAction(
            child: _buildActionIconWithCount(Iconsax.bookmark, 'Lưu', 12),
            shownBottom: 135,
            index: 1,
          ),
          // Icon bình luận (animated)
          _buildAnimatedAction(
            child: _buildActionIconWithCount(Iconsax.message, 'Bình luận', 34),
            shownBottom: 195,
            index: 2,
          ),
          // Icon tim (animated)
          _buildAnimatedAction(
            child: _buildActionIconWithCount(Iconsax.heart, 'Tim', 56),
            shownBottom: 255,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(String tabName) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        post['author'][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['author'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            post['time'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tab indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tabName,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post['content'], style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.like_1),
                      onPressed: () {
                        // TODO: Like post
                      },
                    ),
                    Text('${post['likes']}'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Iconsax.message),
                      onPressed: () {
                        // TODO: Comment on post
                      },
                    ),
                    Text('${post['comments']}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVideoMode = !_isVideoMode;
        });
      },
      child: Container(
        width: 35,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Icon cố định ở trên
            Positioned(
              top: 2,
              left: 0,
              right: 0,
              child: Icon(
                Iconsax.play_circle,
                color: _isVideoMode
                    ? AppTheme.primaryColor
                    : Colors.grey.shade400,
                size: 28,
              ),
            ),
            // Icon cố định ở dưới
            Positioned(
              bottom: 2,
              left: 0,
              right: 0,
              child: Icon(
                Iconsax.document_text,
                color: _isVideoMode
                    ? Colors.grey.shade400
                    : AppTheme.primaryColor,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String tooltip) {
    return IconButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tooltip),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
      icon: Icon(icon, color: AppTheme.primaryColor, size: 24),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      splashRadius: 22,
      tooltip: tooltip,
    );
  }

  Widget _buildActionIconWithCount(IconData icon, String tooltip, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tooltip),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
          icon: Icon(icon, color: AppTheme.primaryColor, size: 24),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          splashRadius: 22,
          tooltip: tooltip,
        ),
        const SizedBox(height: 0),
        Transform.translate(
          offset: const Offset(0, -6),
          child: Text(
            '$count',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 0.9,
            ),
          ),
        ),
      ],
    );
  }

  // Animated positioned helper: when in video mode show at shownBottom, else hide at pill bottom
  Widget _buildAnimatedAction({
    required Widget child,
    required double shownBottom,
    required int index,
  }) {
    const double pillBottom = 20;
    final double hiddenBottom = pillBottom; // Start/end at pill position

    // Staggered animation by index
    final int baseMs = 250;
    final int delayMs = 40 * index;
    final duration = Duration(milliseconds: baseMs + delayMs);

    final double targetBottom = _isVideoMode ? shownBottom : hiddenBottom;
    final double targetOpacity = _isVideoMode ? 1.0 : 0.0;

    return AnimatedPositioned(
      right: 0,
      bottom: targetBottom,
      duration: duration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        duration: duration,
        opacity: targetOpacity,
        curve: Curves.easeOut,
        child: IgnorePointer(ignoring: !_isVideoMode, child: child),
      ),
    );
  }
}
