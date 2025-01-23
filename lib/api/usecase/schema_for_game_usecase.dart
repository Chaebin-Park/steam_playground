import 'package:steamplayground/api/api_config.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';
import 'package:steamplayground/api/param/schema_for_game_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class SchemaForGameUseCase
    implements UseCase<SchemaForGameResponse, SchemaForGameParams> {
  final SteamRepository repository;

  SchemaForGameUseCase({required this.repository});

  @override
  Future<SchemaForGameResponse> execute(SchemaForGameParams params) async {
    try {
      final response = await repository.fetchData(
        endpointKey: '/getSchemaForGame',
        queryParameters: {
          ...params.toQueryParameters(),
        },
      );

      return SchemaForGameResponse.fromJson(response);
    } catch (e) {
      return SchemaForGameResponse(
          game: const GameSchema(
        gameName: '',
        gameVersion: '',
        availableGameStats: AvailableGameStats(achievements: []),
      ));
    }
  }
}
