import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';

class GameItem extends StatelessWidget {
  final OwnedGame game;
  final bool isExpanded;
  final List<SchemaAchievement> achievements;
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: GestureDetector(
        onTap: onItemClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isExpanded
                ? [
                    BoxShadow(
                        color: Colors.black.withAlpha(10),
                        offset: Offset(0, 2),
                        blurRadius: 4)
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGameRow(context),
              if (isExpanded) _buildExpandedContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Image.network(
              'https://cdn.cloudflare.steamstatic.com/steam/apps/${game.appId}/header.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              game.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Achievements:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...achievements.map((achievement) => ListTile(
                leading: Image.network(achievement.icon),
                title: Text(achievement.displayName),
                subtitle: Text(achievement.description),
              )),
        ],
      ),
    );
  }
}
