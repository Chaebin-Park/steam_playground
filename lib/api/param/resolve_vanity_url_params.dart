class ResolveVanityURLParams {
  final String apiKey;
  final String vanityUrl;

  ResolveVanityURLParams({required this.apiKey, required this.vanityUrl});

  Map<String, dynamic> toQueryParameters() {
    return {'key': apiKey, 'vanityurl': vanityUrl};
  }
}
