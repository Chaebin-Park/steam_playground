import 'package:steamplayground/api/models/player_achievements_response.dart';
import 'package:steamplayground/api/param/player_archievements_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerAchievementsUseCase
    implements UseCase<PlayerAchievementsResponse, PlayerAchievementsParams> {
  final SteamRepository repository;
  final String apiKey;

  PlayerAchievementsUseCase({required this.repository, required this.apiKey});

  @override
  Future<PlayerAchievementsResponse> execute(
      PlayerAchievementsParams params) async {
    final response = await repository.fetchData(
      endpointKey: 'getPlayerAchievements',
      queryParameters: {
        ...params.toQueryParameters(),
        'key': apiKey,
      },
    );

    return PlayerAchievementsResponse.fromJson(response);
  }
}
