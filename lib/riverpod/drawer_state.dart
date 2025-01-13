import 'package:steamplayground/api/models/achievement_with_status.dart';

class DrawerState {
  final bool isExpanded;
  final int currentAppId;
  final List<AchievementWithStatus> achievements;

  const DrawerState({
    this.isExpanded = false,
    this.currentAppId = 0,
    this.achievements = const [],
  });
}
