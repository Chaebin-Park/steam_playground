class SchemaForGameResponse {
  final Game game;

  SchemaForGameResponse({required this.game});

  factory SchemaForGameResponse.fromJson(Map<String, dynamic> json) {
    return SchemaForGameResponse(
      game: Game.fromJson(json['game']),
    );
  }
}

class Game {
  final String gameName;
  final String gameVersion;
  final AvailableGameStats availableGameStats;

  Game({
    required this.gameName,
    required this.gameVersion,
    required this.availableGameStats,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameName: json['gameName'],
      gameVersion: json['gameVersion'],
      availableGameStats: AvailableGameStats.fromJson(json['availableGameStats']),
    );
  }
}

class AvailableGameStats {
  final List<Achievement> achievements;

  AvailableGameStats({required this.achievements});

  factory AvailableGameStats.fromJson(Map<String, dynamic> json) {
    return AvailableGameStats(
      achievements: (json['achievements'] as List)
          .map((achievement) => Achievement.fromJson(achievement))
          .toList(),
    );
  }
}

class Achievement {
  final String name;
  final String displayName;
  final String description;
  final String icon;
  final String icongray;

  Achievement({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.icongray,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      name: json['name'],
      displayName: json['displayName'],
      description: json['description'] ?? '',
      icon: json['icon'],
      icongray: json['icongray'],
    );
  }
}
