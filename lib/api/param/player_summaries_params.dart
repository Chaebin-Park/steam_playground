class PlayerSummariesParams {
  final String steamId;

  PlayerSummariesParams({required this.steamId});

  Map<String, dynamic> toQueryParameters() {
    return {'steamids': steamId,};
  }
}
