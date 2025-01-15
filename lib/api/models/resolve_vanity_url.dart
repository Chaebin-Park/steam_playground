class ResolveVanityURLResponse {
  final ResponseData response;

  ResolveVanityURLResponse({required this.response});

  factory ResolveVanityURLResponse.fromJson(Map<String, dynamic> json) {
    return ResolveVanityURLResponse(
      response: ResponseData.fromJson(json['response'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response.toJson(),
    };
  }
}

class ResponseData {
  final int success;
  final String steamid;

  ResponseData({
    required this.success,
    required this.steamid,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      success: json['success'] ?? 0,
      steamid: json['steamid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'steamid': steamid,
    };
  }
}
