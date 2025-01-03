
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerAchievementsUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  PlayerAchievementsUseCase({required this.repository});

  @override
  Future<dynamic> execute(Map<String, dynamic> queryParameters) {
    if (!queryParameters.containsKey('key') || !queryParameters.containsKey('steamids') || !queryParameters.containsKey('appid')) {
      throw Exception('Missing required parameters: key, steamids, appid');
    }

    return repository.fetchData(
      endpointKey: 'getPlayerAchievements',
      queryParameters: queryParameters,
    );
  }
}