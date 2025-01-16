import 'package:steamplayground/api/api_config.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';
import 'package:steamplayground/api/param/schema_for_game_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class SchemaForGameUseCase
    implements UseCase<SchemaForGameResponse, SchemaForGameParams> {
  final SteamRepository repository;
  final String apiKey;

  SchemaForGameUseCase({required this.repository, required this.apiKey});

  @override
  Future<SchemaForGameResponse> execute(SchemaForGameParams params) async {
    try {
      final response = await repository.fetchData(
        endpointKey: ApiConfig.endpoints['getSchemaForGame'].toString(),
        queryParameters: {
          ...params.toQueryParameters(),
          'key': apiKey,
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
