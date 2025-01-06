class OwnedGamesResponse {
  final PlayerStats playerStats;

  OwnedGamesResponse({required this.playerStats});

  factory OwnedGamesResponse.fromJson(Map<String, dynamic> json) {
    return OwnedGamesResponse(
      playerStats: PlayerStats.fromJson(json['playerstats']),
    );
  }
}

class PlayerStats {
  final String steamID;
  final String gameName;

  PlayerStats({
    required this.steamID,
    required this.gameName,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      steamID: json['steamID'],
      gameName: json['gameName'],
    );
  }
}
