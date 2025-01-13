import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';

class ExpandedContent extends StatelessWidget {
  final List<AchievementWithStatus> achievements;

  const ExpandedContent({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final achievement = achievements[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              leading: Image.network(achievement.icon),
              title: Text(achievement.displayName),
              subtitle: Text(achievement.description),
            ),
          );
        },
        childCount: achievements.length,
      ),
    );
  }
}
