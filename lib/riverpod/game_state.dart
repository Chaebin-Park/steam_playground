import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';

class GameDataState {
  final List<OwnedGame> games;
  final Map<int, bool> expandedState;
  final List<AchievementWithStatus> achievements;
  final GameSchema? schema;

  const GameDataState({
    this.games = const [],
    this.expandedState = const {},
    this.achievements = const [],
    this.schema,
  });

  GameDataState copyWith({
    List<OwnedGame>? games,
    Map<int, bool>? expandedState,
    List<AchievementWithStatus>? achievements,
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
