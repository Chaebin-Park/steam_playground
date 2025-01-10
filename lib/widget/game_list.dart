import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/game_item.dart';

class GameList extends ConsumerWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameViewModelProvider);
    final gameViewModel = ref.read(gameViewModelProvider.notifier);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final game = gameState.gameDataState.games[index];
          final isExpanded = gameState.gameDataState.expandedState[game.appId] ?? false;
          final achievements = gameState.gameDataState.achievements[game.appId];

          return GameItem(
            game: game,
            isExpanded: isExpanded,
            achievements: achievements ?? [],
            onItemClick: () {
              gameViewModel.toggleExpandedState(game.appId);
            },
          );
        },
        childCount: gameState.gameDataState.games.length,
      ),
    );
  }
}
