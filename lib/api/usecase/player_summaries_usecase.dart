import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerSummariesUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  PlayerSummariesUseCase({required this.repository});

  @override
  Future<dynamic> execute(Map<String, dynamic> queryParameters) {
    if (!queryParameters.containsKey('key') || !queryParameters.containsKey('steamids')) {
      throw Exception('Missing required parameters: key, steamids');
    }

    return repository.fetchData(
      endpointKey: 'getPlayerSummaries',
      queryParameters: queryParameters,
    );
  }
}