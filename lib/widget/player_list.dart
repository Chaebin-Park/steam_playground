import 'package:flutter/cupertino.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/widget/player_card.dart';

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
