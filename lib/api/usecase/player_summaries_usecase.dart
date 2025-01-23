import 'package:flutter/foundation.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/param/player_summaries_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class PlayerSummariesUseCase
    implements UseCase<PlayerSummariesResponse, PlayerSummariesParams> {
  final SteamRepository repository;

  PlayerSummariesUseCase({required this.repository});

  @override
  Future<PlayerSummariesResponse> execute(PlayerSummariesParams params) async {
    try {
      final response = await repository.fetchData(
        endpointKey: '/getPlayerSummaries',
        queryParameters: {
          ...params.toQueryParameters(),
        },
      );
      return PlayerSummariesResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      return PlayerSummariesResponse.fromJson({});
    }
  }
}
