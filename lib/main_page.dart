import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/game_list/game_list.dart';
import 'package:steamplayground/widget/loading_overlay.dart';
import 'package:steamplayground/widget/player_list.dart';
import 'package:steamplayground/widget/search_widget.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModel 상태 구독
    final playerState = ref.watch(playerViewModelProvider);
    final gameState = ref.watch(gameViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 실제 콘텐츠
          CustomScrollView(
            slivers: [
              top(),
              const SearchWidget(), // 검색 위젯
              if (playerState.players.isNotEmpty) PlayerList(), // 플레이어 리스트
              if (gameState.gameDataState.games.isNotEmpty) GameList(), // 게임 리스트
            ],
          ),
          // 로딩 팝업
          if (gameState.loadingState.isLoading)
            LoadingOverlay(loadingState: gameState.loadingState,),
        ],
      ),
    );
  }

  Widget top() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/img_steam_logo_black.png',
              width: 250,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}


/**
class _MainPage extends ConsumerState<MainPage> {
  final Set<Player> _playerSet = {};
  final Set<OwnedGame> _games = {};

  bool _isLoading = false;
  int _currentIndex = 0;
  int _totalSteps = 0;
  String _loadingDescription = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 실제 콘텐츠
          CustomScrollView(
            slivers: [
              top(),
              SearchWidget(),
              if (_playerSet.isNotEmpty) PlayerList(),
              if (_games.isNotEmpty) GameList(),
            ],
          ),
          // 로딩 팝업
          if (_isLoading)
            LoadingOverlay(
                isLoading: _isLoading,
                description: _loadingDescription,
                currentIndex: _currentIndex,
                totalSteps: _totalSteps)
        ],
      ),
    );
  }

  Widget top() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/img_steam_logo_black.png',
              width: 250,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
**/