class OwnedGamesResponse {
  final ResponseData response;

  OwnedGamesResponse({required this.response});

  factory OwnedGamesResponse.fromJson(Map<String, dynamic> json) {
    return OwnedGamesResponse(
      response: ResponseData.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response.toJson(),
    };
  }
}

class ResponseData {
  final int gameCount;
  final List<Game> games;

  ResponseData({required this.gameCount, required this.games});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      gameCount: json['game_count'],
      games: (json['games'] as List).map((game) => Game.fromJson(game)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_count': gameCount,
      'games': games.map((game) => game.toJson()).toList(),
    };
  }
}

class Game {
  final int appId;
  final String name;
  final String imgIconUrl;
  final bool hasCommunityVisibleStats;
  final int playtimeForever;
  final int playtimeWindowsForever;
  final int playtimeMacForever;
  final int playtimeLinuxForever;
  final int playtimeDeckForever;
  final int rtimeLastPlayed;
  final int playtimeDisconnected;
  final int? playtime2weeks; // Nullable as it may not exist in all games

  Game({
    required this.appId,
    required this.name,
    required this.imgIconUrl,
    required this.hasCommunityVisibleStats,
    required this.playtimeForever,
    required this.playtimeWindowsForever,
    required this.playtimeMacForever,
    required this.playtimeLinuxForever,
    required this.playtimeDeckForever,
    required this.rtimeLastPlayed,
    required this.playtimeDisconnected,
    this.playtime2weeks,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      appId: json['appid'],
      name: json['name'],
      imgIconUrl: json['img_icon_url'],
      hasCommunityVisibleStats: json['has_community_visible_stats'],
      playtimeForever: json['playtime_forever'],
      playtimeWindowsForever: json['playtime_windows_forever'],
      playtimeMacForever: json['playtime_mac_forever'],
      playtimeLinuxForever: json['playtime_linux_forever'],
      playtimeDeckForever: json['playtime_deck_forever'],
      rtimeLastPlayed: json['rtime_last_played'],
      playtimeDisconnected: json['playtime_disconnected'],
      playtime2weeks: json['playtime_2weeks'], // Nullable field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appid': appId,
      'playtime_forever': playtimeForever,
      'playtime_windows_forever': playtimeWindowsForever,
      'playtime_mac_forever': playtimeMacForever,
      'playtime_linux_forever': playtimeLinuxForever,
      'playtime_deck_forever': playtimeDeckForever,
      'rtime_last_played': rtimeLastPlayed,
      'playtime_disconnected': playtimeDisconnected,
      if (playtime2weeks != null) 'playtime_2weeks': playtime2weeks,
    };
  }
}
