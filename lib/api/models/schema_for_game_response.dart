class SchemaForGameResponse {
  final SchemaGame game;

  SchemaForGameResponse({required this.game});

  factory SchemaForGameResponse.fromJson(Map<String, dynamic> json) {
    return SchemaForGameResponse(
      game: SchemaGame.fromJson(json['game']),
    );
  }
}

class SchemaGame {
  final String? gameName;
  final String gameVersion;
  final AvailableGameStats availableGameStats;

  SchemaGame({
    required this.gameName,
    required this.gameVersion,
    required this.availableGameStats,
  });

  factory SchemaGame.fromJson(Map<String, dynamic> json) {
    return SchemaGame(
      gameName: json['gameName'],
      gameVersion: json['gameVersion'],
      availableGameStats: AvailableGameStats.fromJson(json['availableGameStats']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SchemaGame && other.gameName == gameName;
  }

  @override
  int get hashCode => gameName.hashCode;
}

class AvailableGameStats {
  final List<SchemaAchievement> achievements;

  AvailableGameStats({required this.achievements});

  factory AvailableGameStats.fromJson(Map<String, dynamic> json) {
    return AvailableGameStats(
      achievements: (json['achievements'] as List)
          .map((achievement) => SchemaAchievement.fromJson(achievement))
          .toList(),
    );
  }
}

class SchemaAchievement {
  final String name;
  final String displayName;
  final String description;
  final String icon;
  final String iconGray;

  SchemaAchievement({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.iconGray,
  });

  factory SchemaAchievement.fromJson(Map<String, dynamic> json) {
    return SchemaAchievement(
      name: json['name'],
      displayName: json['displayName'],
      description: json['description'] ?? '',
      icon: json['icon'],
      iconGray: json['icongray'],
    );
  }
}
