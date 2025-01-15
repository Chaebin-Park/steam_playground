class PlayerSummariesResponse {
  final ResponseData response;

  PlayerSummariesResponse({required this.response});

  factory PlayerSummariesResponse.fromJson(Map<String, dynamic> json) {
    return PlayerSummariesResponse(
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
  final List<Player> players;

  ResponseData({required this.players});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      players: (json['players'] as List?)
          ?.map((player) => Player.fromJson(player))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}

class Player {
  final String steamId;
  final String personaName;
  final String profileUrl;
  final String avatar;
  final String avatarFull;
  final int lastLogoff;
  final String realName;

  Player({
    required this.steamId,
    required this.personaName,
    required this.profileUrl,
    required this.avatar,
    required this.avatarFull,
    required this.lastLogoff,
    required this.realName,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      steamId: json['steamid'] ?? '',
      personaName: json['personaname'] ?? '',
      profileUrl: json['profileurl'] ?? '',
      avatar: json['avatar'] ?? '',
      avatarFull: json['avatarfull'] ?? '',
      lastLogoff: json['lastlogoff'] ?? 0,
      realName: json['realname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steamid': steamId,
      'personaname': personaName,
      'profileurl': profileUrl,
      'avatar': avatar,
      'avatarfull': avatarFull,
      'lastlogoff': lastLogoff,
      'realname': realName,
    };
  }
}
