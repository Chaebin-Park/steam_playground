class ResolveVanityURLParams {
  final String vanityUrl;

  ResolveVanityURLParams({required this.vanityUrl});

  Map<String, dynamic> toQueryParameters() {
    return {'vanityurl': vanityUrl};
  }
}
