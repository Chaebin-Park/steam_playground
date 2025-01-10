class OwnedGamesParams {
  final String apiKey;
  final String steamId;
  final bool includeAppInfo;
  final bool includePlayedFreeGames;
  final String format;

  OwnedGamesParams({
    required this.apiKey,
    required this.steamId,
    this.includeAppInfo = true,
    this.includePlayedFreeGames = true,
    this.format = 'json',
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'key': apiKey,
      'steamid': steamId,
      'include_appinfo': includeAppInfo ? 1 : 0,
      'include_played_free_game': includePlayedFreeGames ? 1 : 0,
      'format': format,
    };
  }
}
