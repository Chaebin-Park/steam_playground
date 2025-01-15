class PlayerSummariesResponse {
  final ResponseData response;

  PlayerSummariesResponse({required this.response});

  factory PlayerSummariesResponse.fromJson(Map<String, dynamic> json) {
    return PlayerSummariesResponse(
      response: ResponseData.fromJson(json['response']),
    );
  }
}

class ResponseData {
  final List<Player> players;

  ResponseData({required this.players});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      players: (json['players'] as List).map((player) => Player.fromJson(player)).toList(),
    );
  }
}

class Player {
  final String steamId;
  final String personaName;
  final String profileUrl;
  final String avatar;
  final String avatarFull;
  final int lastLogoff;
  final String? realName;

  Player({
    required this.steamId,
    required this.personaName,
    required this.profileUrl,
    required this.avatar,
    required this.avatarFull,
    required this.lastLogoff,
    this.realName,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      steamId: json['steamid'],
      personaName: json['personaname'],
      profileUrl: json['profileurl'],
      avatar: json['avatar'],
      avatarFull: json['avatarfull'],
      lastLogoff: json['lastlogoff'],
      realName: json['realname'],
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player && other.steamId == steamId;
  }

  @override
  int get hashCode => steamId.hashCode;
}
