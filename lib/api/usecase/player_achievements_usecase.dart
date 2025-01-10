import 'package:steamplayground/api/models/player_achievements_response.dart';
import 'package:steamplayground/api/param/player_archievements_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerAchievementsUseCase
    implements UseCase<PlayerAchievementsResponse, PlayerAchievementsParams> {
  final SteamRepository repository;

  PlayerAchievementsUseCase({required this.repository});

  @override
  Future<PlayerAchievementsResponse> execute(PlayerAchievementsParams params) async {
    final response = await repository.fetchData(
      endpointKey: 'getPlayerAchievements',
      queryParameters: params.toQueryParameters(),
    );

    return PlayerAchievementsResponse.fromJson(response);
  }
}
