import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/widget/game_list/expanded_content.dart';
import 'package:steamplayground/riverpod/provider.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  final double width;

  const DrawerWidget({super.key, required this.width});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant DrawerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 스크롤을 최상단으로 이동
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameViewModelProvider);
    final gameViewModel = ref.read(gameViewModelProvider.notifier);

    return AnimatedPositioned(
      right: gameState.drawerState.isExpanded ? 0 : -widget.width,
      width: widget.width,
      height: MediaQuery.of(context).size.height,
      duration: const Duration(milliseconds: 300),
      child: Material(
        elevation: 8,
        color: Colors.white,
        child: Column(
          children: [
            // 닫기 버튼은 항상 최상단
            _buildCloseButton(gameViewModel),
            // 리스트 또는 빈 메시지
            Expanded(
              child: _buildContent(gameState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(dynamic gameViewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            gameViewModel.closeDrawer();
          },
        ),
      ),
    );
  }

  Widget _buildContent(dynamic gameState) {
    if (gameState.drawerState.achievements.isEmpty) {
      return _buildEmptyMessage();
    } else {
      return _buildAchievementsList(gameState);
    }
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            const Text(
              'No achievements available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(dynamic gameState) {
    return CustomScrollView(
      controller: _scrollController, // ScrollController 추가
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ExpandedContent(
          achievements: gameState.drawerState.achievements,
        ),
      ],
    );
  }
}
