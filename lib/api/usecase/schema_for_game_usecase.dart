import 'package:steamplayground/api/models/schema_for_game_response.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class SchemaForGameUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  SchemaForGameUseCase({required this.repository});

  @override
  Future<SchemaForGameResponse> execute(Map<String, dynamic> queryParameters) async {
    if (!queryParameters.containsKey('key') ||
        !queryParameters.containsKey('appid')) {
      throw Exception(
          'SchemaForGameUseCase Missing required parameters: key, appid');
    }

    final response = await repository.fetchData(
        endpointKey: 'getSchemaForGame', queryParameters: queryParameters);

    return SchemaForGameResponse.fromJson(response);
  }
}
