import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/player_card.dart';

/**
class PlayerList extends StatelessWidget {
  final Set<Player> players;
  final String currentSteamId;
  final Function(String steamId) onPlayerSelected;

  const PlayerList({
    super.key,
    required this.players,
    required this.currentSteamId,
    required this.onPlayerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players.elementAt(index);
              return PlayerCard(
                  player: player,
                  isSelected: player.steamId == currentSteamId,
                  onTap: () => onPlayerSelected(player.steamId));
            }),
      ),
    );
  }
}
    **/

class PlayerList extends ConsumerWidget {
  const PlayerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerViewModelProvider);
    final playerViewModel = ref.read(playerViewModelProvider.notifier);
    final gameViewModel = ref.read(gameViewModelProvider.notifier);

    print("5. Player");
    if (playerState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: playerState.players.length,
          itemBuilder: (context, index) {
            final player = playerState.players.elementAt(index);
            return PlayerCard(
              player: player,
              isSelected: player.steamId == playerState.selectedSteamId,
              onTap: () {
                playerViewModel.selectPlayer(player.steamId);
                gameViewModel.fetchOwnedGames(player.steamId);
              },
            );
          },
        ),
      ),
    );
  }
}

