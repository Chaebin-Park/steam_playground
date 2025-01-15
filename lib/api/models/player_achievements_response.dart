class PlayerAchievementsResponse {
  final PlayerStats playerStats;

  PlayerAchievementsResponse({required this.playerStats});

  factory PlayerAchievementsResponse.fromJson(Map<String, dynamic> json) {
    return PlayerAchievementsResponse(
      playerStats: PlayerStats.fromJson(json['playerstats'] ?? {}),
    );
  }
}

class PlayerStats {
  final String steamID;
  final String gameName;
  final List<PlayerAchievement> achievements;

  PlayerStats({
    required this.steamID,
    required this.gameName,
    required this.achievements,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      steamID: json['steamID'] ?? '',
      gameName: json['gameName'] ?? '',
      achievements: (json['achievements'] as List<dynamic>? ?? [])
          .map((achievement) => PlayerAchievement.fromJson(achievement))
          .toList(),
    );
  }
}

class PlayerAchievement {
  final String apiName;
  final int achieved;
  final int unLockTime;

  PlayerAchievement({
    required this.apiName,
    required this.achieved,
    required this.unLockTime,
  });

  factory PlayerAchievement.fromJson(Map<String, dynamic> json) {
    return PlayerAchievement(
      apiName: json['apiname'] ?? '',
      achieved: json['achieved'] ?? 0,
      unLockTime: json['unlocktime'] ?? 0,
    );
  }
}
