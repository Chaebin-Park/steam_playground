import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';

class ExpandedContent extends StatelessWidget {
  final List<AchievementWithStatus> achievements;

  const ExpandedContent({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: achievements
            .map(
              (achievement) => ListTile(
            leading: Image.network(achievement.icon),
            title: Text(achievement.displayName),
            subtitle: Text(achievement.description),
          ),
        )
            .toList(),
      ),
    );
  }
}