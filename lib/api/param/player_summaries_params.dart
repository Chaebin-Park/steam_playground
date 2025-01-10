class PlayerSummariesParams {
  final String apiKey;
  final String steamId;

  PlayerSummariesParams({required this.apiKey, required this.steamId});

  Map<String, dynamic> toQueryParameters() {
    return {
      'key': apiKey,
      'steamid': steamId,
    };
  }
}
