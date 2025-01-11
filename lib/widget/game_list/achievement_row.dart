import 'package:flutter/cupertino.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/widget/game_list/achievement_progress_bar.dart';

class AchievementsRow extends StatelessWidget {
  final List<AchievementWithStatus> achievements;

  const AchievementsRow({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    int achievedCount = achievements.where((ach) => ach.isAchieved).length;
    double achievementRate = achievements.isEmpty ? 0 : achievedCount / achievements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Achievements $achievedCount/${achievements.length}",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        AchievementProgressBar(rate: achievementRate),
      ],
    );
  }
}