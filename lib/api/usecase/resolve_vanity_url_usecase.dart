import 'package:steamplayground/api/models/resolve_vanity_url.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class ResolveVanityURLUseCase implements UseCase<dynamic, Map<String, dynamic>> {
  final SteamRepository repository;

  ResolveVanityURLUseCase({required this.repository});

  @override
  Future<ResolveVanityURLResponse> execute(Map<String, dynamic> queryParameters) async {
    if (!queryParameters.containsKey('key') || !queryParameters.containsKey('vanityurl')) {
      throw Exception('Missing required parameters: key, vanityurl');
    }

    final response = await repository.fetchData(endpointKey: 'resolveVanityURL', queryParameters: queryParameters);

    return ResolveVanityURLResponse.fromJson(response);
  }
}