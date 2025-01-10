import 'package:steamplayground/riverpod/game_state.dart';
import 'package:steamplayground/riverpod/loading_state.dart';

class CombinedState {
  final LoadingState loadingState;
  final GameDataState gameDataState;

  CombinedState({LoadingState? loadingState, GameDataState? gameDataState})
      : loadingState = loadingState ?? LoadingState(),
        gameDataState = gameDataState ?? GameDataState();

  CombinedState copyWith({
    LoadingState? loadingState,
    GameDataState? gameDataState
  }) {
    return CombinedState(
        loadingState: loadingState ?? this.loadingState,
        gameDataState: gameDataState ?? this.gameDataState
    );
  }
}
