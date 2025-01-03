import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/api_config.dart';

import 'steam_repository.dart';

class SteamRepositoryImpl implements SteamRepository {
  final ApiClient apiClient;

  SteamRepositoryImpl({required this.apiClient});

  @override
  Future<dynamic> fetchData({
    required String endpointKey,
    required Map<String, dynamic> queryParameters,
  }) async {
    final endpoint = ApiConfig.endpoints[endpointKey];
    if (endpoint == null) {
      throw Exception('Endpoint $endpointKey is not defined');
    }

    final serializedQueryParameters = queryParameters.map((key, value) {
      if (value is List<String>) {
        return MapEntry(key, value.join(','));
      }
      return MapEntry(key, value);
    });

    return await apiClient.get(endpoint: endpoint, queryParameters: serializedQueryParameters);
  }
}
