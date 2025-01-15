import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/drawer_widget.dart';
import 'package:steamplayground/widget/game_list/game_list.dart';
import 'package:steamplayground/widget/loading_overlay.dart';
import 'package:steamplayground/widget/player_list/player_list.dart';
import 'package:steamplayground/widget/search_widget.dart';
import 'package:steamplayground/widget/top_widget.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final gameState = ref.watch(gameViewModelProvider);

    final bool playerListChecker = playerState.players.isNotEmpty;
    final bool gameListChecker = gameState.gameDataState.games.isNotEmpty;
    final double drawerWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          // 실제 콘텐츠
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width -
                (gameState.drawerState.isExpanded ? drawerWidth / 2 : 0),
            height: MediaQuery.of(context).size.height,
            child: CustomScrollView(
              slivers: [
                TopWidget(),
                const SearchWidget(), // 검색 위젯
                if (playerListChecker) PlayerList(), // 플레이어 리스트
                if (gameListChecker) GameList(), // 게임 리스트
              ],
            ),
          ),
          DrawerWidget(width: drawerWidth),
          // 로딩 팝업
          if (gameState.loadingState.isLoading)
            LoadingOverlay(
              loadingState: gameState.loadingState,
            ),
        ],
      ),
    );
  }
}
