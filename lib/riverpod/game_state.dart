import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/player_achievements_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';

class GameDataState {
  final List<OwnedGame> games;
  final List<bool> expandedState;
  final List<PlayerAchievement> achievements;
  final GameSchema? schema; // GameSchema로 변경

  const GameDataState({
    this.games = const [],
    this.expandedState = const [],
    this.achievements = const [],
    this.schema,
  });

  GameDataState copyWith({
    List<OwnedGame>? games,
    List<bool>? expandedState,
    List<PlayerAchievement>? achievements,
    GameSchema? schema,
  }) {
    return GameDataState(
      games: games ?? this.games,
      expandedState: expandedState ?? this.expandedState,
      achievements: achievements ?? this.achievements,
      schema: schema ?? this.schema,
    );
  }
}
