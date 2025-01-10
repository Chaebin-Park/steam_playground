import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/param/player_summaries_params.dart';
import 'package:steamplayground/api/param/resolve_vanity_url_params.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';
import 'package:steamplayground/api/usecase/resolve_vanity_url_usecase.dart';
import 'package:steamplayground/riverpod/player_state.dart';

class PlayerViewModel extends StateNotifier<PlayerState> {
  final PlayerSummariesUseCase playerSummariesUseCase;
  final ResolveVanityURLUseCase resolveVanityURLUseCase;

  PlayerViewModel({
    required this.playerSummariesUseCase,
    required this.resolveVanityURLUseCase,
  }) : super(const PlayerState());

  Future<void> fetchPlayerSummaries(String url) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      String? steamId;

      // URL에서 Steam ID 추출
      if (url.contains('/profiles/')) {
        final regex = RegExp(r'profiles/(\d+)/?');
        final match = regex.firstMatch(url);
        steamId = match?.group(1);
      } else if (url.contains('/id/')) {
        final regex = RegExp(r'id/([^/]+)/?');
        final match = regex.firstMatch(url);
        if (match != null) {
          final vanityUrl = match.group(1);
          final response = await resolveVanityURLUseCase.execute(
            ResolveVanityURLParams(vanityUrl: vanityUrl!),
          );
          steamId = response.response.steamid;
        }
      }

      if (steamId == null) {
        throw Exception('Invalid URL');
      }

      // 플레이어 정보 가져오기
      final response = await playerSummariesUseCase.execute(
        PlayerSummariesParams(steamId: steamId),
      );

      state = state.copyWith(
        players: {...state.players, response.response.players.first},
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectPlayer(String steamId) {
    state = state.copyWith(selectedSteamId: steamId);
  }
}
