class PlayerAchievementsParams {
  final String steamId;
  final int appId;

  PlayerAchievementsParams({
    required this.steamId,
    required this.appId,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'steamid': steamId,
      'appid': appId,
    };
  }
}
