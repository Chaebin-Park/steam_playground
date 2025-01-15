import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class OwnedGamesUseCase
    implements UseCase<OwnedGamesResponse, OwnedGamesParams> {
  final SteamRepository repository;
  final String apiKey;

  OwnedGamesUseCase({required this.repository, required this.apiKey});

  @override
  Future<OwnedGamesResponse> execute(OwnedGamesParams params) async {
    try {
      final response = await repository.fetchData(
        endpointKey: 'getOwnedGames',
        queryParameters: {
          ...params.toQueryParameters(),
          'key': apiKey,
        },
      );

      return OwnedGamesResponse.fromJson(response);
    } catch (e) {
      return OwnedGamesResponse(
          response: ResponseData(gameCount: 0, games: []));
    }
  }
}
