import 'package:steamplayground/riverpod/drawer_state.dart';
import 'package:steamplayground/riverpod/game_state.dart';
import 'package:steamplayground/riverpod/loading_state.dart';

class CombinedState {
  final LoadingState loadingState;
  final GameDataState gameDataState;
  final DrawerState drawerState;

  CombinedState(
      {LoadingState? loadingState,
      GameDataState? gameDataState,
      DrawerState? drawerState})
      : loadingState = loadingState ?? const LoadingState(),
        gameDataState = gameDataState ?? const GameDataState(),
        drawerState = drawerState ?? const DrawerState();

  CombinedState copyWith(
      {LoadingState? loadingState,
      GameDataState? gameDataState,
      DrawerState? drawerState}) {
    return CombinedState(
        loadingState: loadingState ?? this.loadingState,
        gameDataState: gameDataState ?? this.gameDataState,
        drawerState: drawerState ?? this.drawerState);
  }
}
