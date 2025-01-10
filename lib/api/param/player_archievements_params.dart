class PlayerAchievementsParams {
  final String apiKey;
  final String steamId;
  final int appId;

  PlayerAchievementsParams({
    required this.apiKey,
    required this.steamId,
    required this.appId,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'key': apiKey,
      'steamid': steamId,
      'appid': appId,
    };
  }
}
