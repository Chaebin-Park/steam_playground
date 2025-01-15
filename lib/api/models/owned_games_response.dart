class OwnedGamesResponse {
  final ResponseData response;

  OwnedGamesResponse({required this.response});

  factory OwnedGamesResponse.fromJson(Map<String, dynamic> json) {
    return OwnedGamesResponse(
      response: ResponseData.fromJson(json['response'] ?? {}),
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
  final List<OwnedGame> games;

  ResponseData({
    required this.gameCount,
    required this.games,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      gameCount: json['game_count'] ?? 0,
      games: (json['games'] as List?)
          ?.map((game) => OwnedGame.fromJson(game))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_count': gameCount,
      'games': games.map((game) => game.toJson()).toList(),
    };
  }
}

class OwnedGame {
  final int appId;
  final String name;
  final String imgIconUrl;
  final int playtimeForever;
  final bool hasCommunityVisibleStats;
  final List<int> contentDescriptorIds;
  final bool hasLeaderboards;

  OwnedGame({
    required this.appId,
    required this.name,
    required this.imgIconUrl,
    required this.playtimeForever,
    required this.hasCommunityVisibleStats,
    required this.contentDescriptorIds,
    required this.hasLeaderboards,
  });

  factory OwnedGame.fromJson(Map<String, dynamic> json) {
    return OwnedGame(
      appId: json['appid'] ?? 0,
      name: json['name'] ?? '',
      imgIconUrl: json['img_icon_url'] ?? '',
      playtimeForever: json['playtime_forever'] ?? 0,
      hasCommunityVisibleStats: json['has_community_visible_stats'] ?? false,
      contentDescriptorIds: (json['content_descriptorids'] as List?)
          ?.map((id) => id as int)
          .toList() ??
          [],
      hasLeaderboards: json['has_leaderboards'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appid': appId,
      'name': name,
      'img_icon_url': imgIconUrl,
      'playtime_forever': playtimeForever,
      'has_community_visible_stats': hasCommunityVisibleStats,
      'content_descriptorids': contentDescriptorIds,
      'has_leaderboards': hasLeaderboards,
    };
  }
}
