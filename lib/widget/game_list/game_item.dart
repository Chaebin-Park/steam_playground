import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/widget/game_list/expanded_content.dart';
import 'package:steamplayground/widget/game_list/game_row.dart';

class GameItem extends StatelessWidget {
  final OwnedGame game;
  final bool isExpanded;
  final List<AchievementWithStatus> achievements;
  final VoidCallback onItemClick;

  const GameItem({
    super.key,
    required this.game,
    required this.isExpanded,
    required this.achievements,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: GestureDetector(
        onTap: onItemClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GameRow(
                game: game,
                achievements: achievements,
                isExpanded: isExpanded,
              ),
              if (isExpanded) ExpandedContent(achievements: achievements),
            ],
          ),
        ),
      ),
    );
  }
}
