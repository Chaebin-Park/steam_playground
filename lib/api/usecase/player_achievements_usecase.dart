import 'package:steamplayground/api/models/player_achievements_response.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerAchievementsUseCase
    implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  PlayerAchievementsUseCase({required this.repository});

  @override
  Future<PlayerAchievementsResponse> execute(
      Map<String, dynamic> queryParameters) async {
    if (!queryParameters.containsKey('key') ||
        !queryParameters.containsKey('steamid') ||
        !queryParameters.containsKey('appid')) {
      throw Exception('PlayerAchievementsUseCase Missing required parameters: key, steamid, appid');
    }

    final response = await repository.fetchData(
        endpointKey: 'getPlayerAchievements',
        queryParameters: queryParameters
    );

    return PlayerAchievementsResponse.fromJson(response);
  }
}
