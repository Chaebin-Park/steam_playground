import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class OwnedGamesUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  OwnedGamesUseCase({required this.repository});

  @override
  Future<OwnedGamesResponse> execute(Map<String, dynamic> queryParameters) async {
    Map<String, dynamic> options = {
      'include_appinfo': 1,
      'include_played_free_game': 1,
      'format': 'json'
    };
    queryParameters.addAll(options);
    if (!queryParameters.containsKey('key') || !queryParameters.containsKey('steamid')) {
      throw Exception('Missing required parameters: key, steamid');
    }

    final response = await repository.fetchData(
      endpointKey: 'getOwnedGames',
      queryParameters: queryParameters,
    );

    return OwnedGamesResponse.fromJson(response);
  }
}