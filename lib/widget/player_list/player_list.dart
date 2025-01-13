import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/viewmodel/game_viewmodel.dart';
import 'package:steamplayground/viewmodel/player_viewmodel.dart';
import 'package:steamplayground/widget/player_list/player_card.dart';

class PlayerList extends ConsumerWidget {
  const PlayerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final playerViewModel = ref.read(playerViewModelProvider.notifier);
    final gameViewModel = ref.read(gameViewModelProvider.notifier);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: playerState.players.length,
          itemBuilder: (context, index) {
            final player = playerState.players.elementAt(index);
            return PlayerCard(
              key: ValueKey(player.steamId),
              player: player,
              isSelected: player.steamId == playerState.selectedSteamId,
              onTap: () {
                _onPlayerSelected(
                  playerViewModel,
                  gameViewModel,
                  player.steamId,
                );
                gameViewModel.closeDrawer();
              }
            );
          },
        ),
      ),
    );
  }

  void _onPlayerSelected(
    PlayerViewModel playerViewModel,
    GameViewModel gameViewModel,
    String steamId,
  ) {
    playerViewModel.selectPlayer(steamId);
    gameViewModel.fetchOwnedGames(steamId);
  }
}
