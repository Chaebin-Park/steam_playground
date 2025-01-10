import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/game_item.dart';

/**
class GameList extends StatelessWidget {
  final List<OwnedGame> games;
  final Map<int, bool> expandedState;
  final Map<int, GameSchema> gameSchema;
  final Function(int index) onItemClick;

  const GameList(
      {super.key,
      required this.games,
      required this.expandedState,
      required this.gameSchema,
      required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      final game = games[index];
      final isExpanded = expandedState[index] ?? false;
      final achievements =
          gameSchema[game.appId]?.availableGameStats.achievements ?? [];

      return GameItem(
          game: game,
          isExpanded: isExpanded,
          achievements: achievements,
          onItemClick: () => onItemClick(index));
    }, childCount: games.length));
  }
}
**/

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
          final isExpanded = gameState.gameDataState.expandedState[index] ?? false;
          final schema = gameState.gameDataState.schema; // 단일 schema 사용
          final achievements = schema?.availableGameStats.achievements ?? [];

          return GameItem(
            game: game,
            isExpanded: isExpanded,
            achievements: achievements,
            onItemClick: () => gameViewModel.fetchGameDetails(
              'STEAM_ID', // 실제 스팀 ID 사용
              game.appId,
            ),
          );
        },
        childCount: gameState.gameDataState.games.length,
      ),
    );
  }
}
