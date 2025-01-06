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
  final List<Achievement> achievements;

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
          .map((achievement) => Achievement.fromJson(achievement))
          .toList(),
    );
  }
}

class Achievement {
  final String apiname;
  final int achieved;
  final int unlocktime;

  Achievement({
    required this.apiname,
    required this.achieved,
    required this.unlocktime,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      apiname: json['apiname'],
      achieved: json['achieved'],
      unlocktime: json['unlocktime'],
    );
  }
}
