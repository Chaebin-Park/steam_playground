import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class OwnedGamesUseCase implements UseCase<OwnedGamesResponse, OwnedGamesParams> {
  final SteamRepository repository;

  OwnedGamesUseCase({required this.repository});

  @override
  Future<OwnedGamesResponse> execute(OwnedGamesParams params) async {
    final response = await repository.fetchData(
      endpointKey: 'getOwnedGames',
      queryParameters: params.toQueryParameters(),
    );

    return OwnedGamesResponse.fromJson(response);
  }
}