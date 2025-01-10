abstract class SteamRepository {
  Future<dynamic> fetchData({
    required String endpointKey,
    required Map<String, dynamic> queryParameters,
  });
}

/*
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/player_achievements_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';

abstract class SteamRepository {
  Future<OwnedGamesResponse> fetchOwnedGames(Map<String, dynamic> params);
  Future<PlayerAchievementsResponse> fetchPlayerAchievements(Map<String, dynamic> params);
  Future<SchemaForGameResponse> fetchSchemaForGame(Map<String, dynamic> params);
}
*/