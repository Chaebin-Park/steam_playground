import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/widget/game_list/achievement_row.dart';
import 'dart:math' as math;

class GameRow extends StatelessWidget {
  final OwnedGame game;
  final List<AchievementWithStatus> achievements;
  final bool isExpanded;

  const GameRow({
    super.key,
    required this.game,
    required this.achievements,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    double imageWidth = math.min(
      MediaQuery.of(context).size.width * 0.3,
      200,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: imageWidth,
            child: Image.network(
              'https://cdn.cloudflare.steamstatic.com/steam/apps/${game.appId}/header.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      calcPlayTime(game.playtimeForever)
                    )
                  ],
                ),
                const SizedBox(height: 8),
                AchievementsRow(achievements: achievements),
              ],
            ),
          ),
          Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        ],
      ),
    );
  }

  String calcPlayTime(int playtimeMinutes) {
    int hours = playtimeMinutes ~/ 60;
    int minutes = playtimeMinutes % 60;

    return "$hours h $minutes m";
  }
}