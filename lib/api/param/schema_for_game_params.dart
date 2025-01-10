class SchemaForGameParams {
  final String apiKey;
  final int appId;

  SchemaForGameParams({
    required this.apiKey,
    required this.appId,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'key': apiKey,
      'appid': appId,
    };
  }
}
