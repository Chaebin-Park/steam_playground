class PlayerAchievementsResponse {
  final PlayerStats playerStats;

  PlayerAchievementsResponse({required this.playerStats});

  factory PlayerAchievementsResponse.fromJson(Map<String, dynamic> json) {
    return PlayerAchievementsResponse(
      playerStats: PlayerStats.fromJson(json['playerstats']),
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
      steamID: json['steamID'],
      gameName: json['gameName'],
      achievements: (json['achievements'] as List)
          .map((achievement) => PlayerAchievement.fromJson(achievement))
          .toList(),
    );
  }
}

class PlayerAchievement {
  final String apiname;
  final int achieved;
  final int unlocktime;

  PlayerAchievement({
    required this.apiname,
    required this.achieved,
    required this.unlocktime,
  });

  factory PlayerAchievement.fromJson(Map<String, dynamic> json) {
    return PlayerAchievement(
      apiname: json['apiname'],
      achieved: json['achieved'],
      unlocktime: json['unlocktime'],
    );
  }
}
