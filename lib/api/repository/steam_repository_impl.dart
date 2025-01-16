import 'dart:convert';
import 'steam_repository.dart';
import 'package:http/http.dart' as http;

class SteamRepositoryImpl implements SteamRepository {
  final String functionsBaseUrl;

  SteamRepositoryImpl({required this.functionsBaseUrl});

  @override
  Future<dynamic> fetchData({
    required String endpointKey,
    required Map<String, dynamic> queryParameters,
  }) async {
    final url = Uri.parse('$functionsBaseUrl/$endpointKey');  // Firebase Function URL
    final response = await http.get(
      url.replace(queryParameters: queryParameters),  // URL 쿼리 파라미터로 전달
    );

    return json.decode(response.body);  // JSON 형태로 응답 처리
  }
}
