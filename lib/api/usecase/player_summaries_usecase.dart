import 'package:steamplayground/api/api_config.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/param/player_summaries_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerSummariesUseCase
    implements UseCase<PlayerSummariesResponse, PlayerSummariesParams> {
  final SteamRepository repository;
  final String apiKey;

  PlayerSummariesUseCase({required this.repository, required this.apiKey});

  @override
  Future<PlayerSummariesResponse> execute(PlayerSummariesParams params) async {
    try {
      final response = await repository.fetchData(
        endpointKey: ApiConfig.endpoints['getPlayerSummaries'].toString(),
        queryParameters: {
          ...params.toQueryParameters(),
          'key': apiKey,
        },
      );

      return PlayerSummariesResponse.fromJson(response);
    } catch (e) {
      return PlayerSummariesResponse.fromJson({});
    }
  }
}
