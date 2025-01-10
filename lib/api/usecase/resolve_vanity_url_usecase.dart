import 'package:steamplayground/api/models/resolve_vanity_url.dart';
import 'package:steamplayground/api/param/resolve_vanity_url_params.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/usecase/usecase.dart';

class ResolveVanityURLUseCase
    implements UseCase<ResolveVanityURLResponse, ResolveVanityURLParams> {
  final SteamRepository repository;

  ResolveVanityURLUseCase({required this.repository});

  @override
  Future<ResolveVanityURLResponse> execute(
      ResolveVanityURLParams params) async {
    final response = await repository.fetchData(
        endpointKey: 'resolveVanityURL',
        queryParameters: params.toQueryParameters());

    return ResolveVanityURLResponse.fromJson(response);
  }
}
