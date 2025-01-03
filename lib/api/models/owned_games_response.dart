class OwnedGamesResponse {
  final PlayerStats playerstats;

  OwnedGamesResponse({required this.playerstats});

  factory OwnedGamesResponse.fromJson(Map<String, dynamic> json) {
    return OwnedGamesResponse(
      playerstats: PlayerStats.fromJson(json['playerstats']),
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
