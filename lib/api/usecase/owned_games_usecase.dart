import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class OwnedGamesUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  OwnedGamesUseCase({required this.repository});

  @override
  Future<dynamic> execute(Map<String, dynamic> queryParameters) {
    if (!queryParameters.containsKey('key') || !queryParameters.containsKey('steamids')) {
      throw Exception('Missing required parameters: key, steamids');
    }

    return repository.fetchData(
      endpointKey: 'getOwnedGames',
      queryParameters: queryParameters,
    );
  }
}