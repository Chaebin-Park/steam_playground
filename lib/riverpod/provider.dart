import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/riverpod/game_state.dart';
import 'package:steamplayground/riverpod/loading_state.dart';

final loadingProvider = StateNotifierProvider<LoadingState, bool>(
        (ref) => LoadingState()
);

final gameProvider = StateNotifierProvider<GameState, Set<OwnedGame>>(
        (ref) => GameState()
);