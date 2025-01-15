import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';

class GameDataState {
  final List<OwnedGame> games;
  final Map<int, List<AchievementWithStatus>> achievements;
  final GameSchema schema;

  const GameDataState({
    this.games = const [],
    this.achievements = const {},
    this.schema = const GameSchema(
      gameName: '',
      gameVersion: '',
      availableGameStats: AvailableGameStats(achievements: []),
    ),
  });

  GameDataState copyWith({
    List<OwnedGame>? games,
    Map<int, bool>? expandedState,
    Map<int, List<AchievementWithStatus>>? achievements,
    GameSchema? schema,
  }) {
    return GameDataState(
      games: games ?? this.games,
      achievements: achievements ?? this.achievements,
      schema: schema ?? this.schema,
    );
  }
}
