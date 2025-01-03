import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerSummariesUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  PlayerSummariesUseCase({required this.repository});

  @override
  Future<PlayerSummariesResponse> execute(Map<String, dynamic> queryParameters) async {
    if (!queryParameters.containsKey('key') || !queryParameters.containsKey('steamids')) {
      throw Exception('Missing required parameters: key, steamids');
    }
    
    final response = await repository.fetchData(endpointKey: 'getPlayerSummaries', queryParameters: queryParameters);

    return PlayerSummariesResponse.fromJson(response);
  }
}