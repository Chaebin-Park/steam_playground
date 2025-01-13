import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/game_list/game_item.dart';

class GameList extends ConsumerWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameViewModelProvider);
    final gameViewModel = ref.read(gameViewModelProvider.notifier);

    //gameState.gameDataState.games.sort((a, b) => a.playtimeForever.compareTo(b.playtimeForever)); // 오름차순
    gameState.gameDataState.games.sort((a, b) => b.playtimeForever.compareTo(a.playtimeForever)); // 내림차순

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final game = gameState.gameDataState.games[index];
          final achievements = gameState.gameDataState.achievements[game.appId];

          return GameItem(
            game: game,
            achievements: achievements ?? [],
            onItemClick: (appId) => gameViewModel.openDrawer(achievements??[]),
          );
        },
        childCount: gameState.gameDataState.games.length,
      ),
    );
  }
}
