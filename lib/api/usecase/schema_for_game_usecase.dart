import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class SchemaForGameUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  SchemaForGameUseCase({required this.repository});

  @override
  Future execute(Map<String, dynamic> queryParameters) async {
    if (!queryParameters.containsKey('key') ||
        queryParameters.containsKey('appid')) {
      throw Exception('Missing required parameters: key, appid');
    }

    return repository.fetchData(
        endpointKey: 'getSchemaForGame', queryParameters: queryParameters);
  }
}
