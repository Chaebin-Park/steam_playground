import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/param/player_summaries_params.dart';
import 'package:steamplayground/api/param/resolve_vanity_url_params.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';
import 'package:steamplayground/api/usecase/resolve_vanity_url_usecase.dart';
import 'package:steamplayground/main.dart';
import 'package:steamplayground/riverpod/player_state.dart';

class PlayerViewModel extends StateNotifier<PlayerState> {
  final PlayerSummariesUseCase playerSummariesUseCase;
  final ResolveVanityURLUseCase resolveVanityURLUseCase;

  PlayerViewModel({
    required this.playerSummariesUseCase,
    required this.resolveVanityURLUseCase,
  }) : super(const PlayerState());

  void updatePlayers(Set<Player> players) {
    state = state.copyWith(players: players);
  }

  Future<void> fetchPlayerSummaries(String url) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      String? steamId;

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
        state = state.copyWith(
            isLoading: false, errorMessage: 'Invalid Steam URL.');
        return;
      }

      final response = await playerSummariesUseCase.execute(
        PlayerSummariesParams(steamId: steamId),
      );

      final player = response.response.players.first;

      await playerDB.save(player.steamId, player.toJson());

      state = state.copyWith(
        players: {...state.players, player},
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
