import 'package:steamplayground/api/models/player_summaries_response.dart';

abstract class SteamRepository {
  Future<dynamic> fetchData({
    required String endpointKey,
    required Map<String, dynamic> queryParameters,
  });
}
