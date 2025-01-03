class ApiConfig {
  static const Map<String, String> endpoints = {
    'getSchemaForGame': '/ISteamUserStats/GetSchemaForGame/v2/',
    'getPlayerSummaries': '/ISteamUser/GetPlayerSummaries/v0002/',
    'getPlayerAchievements': '/ISteamUserStats/GetPlayerAchievements/v0001/',
    'getOwnedGames': '/IPlayerService/GetOwnedGames/v0001/',
  };
}