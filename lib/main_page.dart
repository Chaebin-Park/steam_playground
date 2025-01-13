import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/game_list/game_list.dart';
import 'package:steamplayground/widget/loading_overlay.dart';
import 'package:steamplayground/widget/player_list/player_list.dart';
import 'package:steamplayground/widget/search_widget.dart';
import 'package:steamplayground/widget/top.dart';

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
              TopWidget(),
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
}
