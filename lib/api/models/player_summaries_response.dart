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
  final String steamid;
  final String personaname;
  final String profileurl;
  final String avatar;
  final int lastlogoff;
  final String? realname;

  Player({
    required this.steamid,
    required this.personaname,
    required this.profileurl,
    required this.avatar,
    required this.lastlogoff,
    this.realname,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      steamid: json['steamid'],
      personaname: json['personaname'],
      profileurl: json['profileurl'],
      avatar: json['avatar'],
      lastlogoff: json['lastlogoff'],
      realname: json['realname'],
    );
  }
}
