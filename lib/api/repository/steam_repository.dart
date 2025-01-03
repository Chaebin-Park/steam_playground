abstract class SteamRepository {
  Future<dynamic> fetchData({
    required String endpointKey,
    required Map<String, dynamic> queryParameters,
  });
}
