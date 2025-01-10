import 'package:steamplayground/api/models/player_summaries_response.dart';

class PlayerState {
  final Set<Player> players;
  final String? selectedSteamId;
  final bool isLoading;
  final String errorMessage;

  const PlayerState({
    this.players = const {},
    this.selectedSteamId,
    this.isLoading = false,
    this.errorMessage = '',
  });

  PlayerState copyWith({
    Set<Player>? players,
    String? selectedSteamId,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlayerState(
      players: players ?? this.players,
      selectedSteamId: selectedSteamId ?? this.selectedSteamId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
