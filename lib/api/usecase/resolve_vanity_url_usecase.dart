import 'package:steamplayground/api/models/resolve_vanity_url.dart';
import 'package:steamplayground/api/param/resolve_vanity_url_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class ResolveVanityURLUseCase
    implements UseCase<ResolveVanityURLResponse, ResolveVanityURLParams> {
  final SteamRepository repository;
  final String apiKey;

  ResolveVanityURLUseCase({required this.repository, required this.apiKey});

  @override
  Future<ResolveVanityURLResponse> execute(
      ResolveVanityURLParams params) async {
    try {
      final response = await repository.fetchData(
        endpointKey: 'resolveVanityURL',
        queryParameters: {
          ...params.toQueryParameters(),
          'key': apiKey,
        },
      );

      return ResolveVanityURLResponse.fromJson(response);
    } catch (e) {
      return ResolveVanityURLResponse(
          response: ResponseData(success: 0, steamid: ''));
    }
  }
}
