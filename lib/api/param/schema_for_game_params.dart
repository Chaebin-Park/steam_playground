class SchemaForGameParams {
  final int appId;

  SchemaForGameParams({
    required this.appId,
  });

  Map<String, dynamic> toQueryParameters() {
    return {'appid': appId,};
  }
}
