import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
import 'package:steamplayground/api/param/player_archievements_params.dart';
import 'package:steamplayground/api/param/schema_for_game_params.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';
import 'package:steamplayground/riverpod/combined_state.dart';
import 'package:steamplayground/riverpod/game_state.dart';
import 'package:steamplayground/riverpod/loading_state.dart';

class GameViewModel extends StateNotifier<CombinedState> {
  final OwnedGamesUseCase _ownedGamesUseCase;
  final PlayerAchievementsUseCase _playerAchievementsUseCase;
  final SchemaForGameUseCase _schemaForGameUseCase;

  GameViewModel({
    required OwnedGamesUseCase ownedGamesUseCase,
    required PlayerAchievementsUseCase playerAchievementsUseCase,
    required SchemaForGameUseCase schemaForGameUseCase,
  })  : _schemaForGameUseCase = schemaForGameUseCase,
        _playerAchievementsUseCase = playerAchievementsUseCase,
        _ownedGamesUseCase = ownedGamesUseCase,
        super(CombinedState());

  @override
  CombinedState get state => CombinedState(
        gameDataState: GameDataState(), // 초기화
        loadingState: LoadingState(), // 초기화
      );

  /// 게임 리스트 가져오기
  Future<void> fetchOwnedGames(String steamId) async {
    state = state.copyWith(
      loadingState: state.loadingState.copyWith(
        isLoading: true,
        description: "Fetching owned games...",
      ),
    );

    try {
      final response = await _ownedGamesUseCase.execute(
        OwnedGamesParams(steamId: steamId),
      );

      state = state.copyWith(
        gameDataState: state.gameDataState.copyWith(
          games: response.response.games,
          expandedState: {},
        ),
        loadingState: state.loadingState.copyWith(isLoading: false),
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: state.loadingState.copyWith(
          isLoading: false,
          description: "Failed to fetch owned games",
        ),
      );
    }
  }

  /// 게임 세부 정보 가져오기
  Future<void> fetchGameDetails(String steamId, int appId) async {
    try {
      // 스키마 업적 데이터 가져오기
      final schemaResponse = await _schemaForGameUseCase.execute(
        SchemaForGameParams(appId: appId),
      );

      // 플레이어 업적 데이터 가져오기
      final playerAchievementsResponse = await _playerAchievementsUseCase.execute(
        PlayerAchievementsParams(steamId: steamId, appId: appId),
      );

      // 플레이어 업적을 맵으로 변환
      final playerAchievementMap = {
        for (var achievement in playerAchievementsResponse.playerStats.achievements)
          achievement.apiName: achievement.achieved > 0,
      };

      // 병합된 업적 리스트 생성
      final mergedAchievements = schemaResponse.game.availableGameStats.achievements.map((achievement) {
        final isAchieved = playerAchievementMap[achievement.name] ?? false;

        return AchievementWithStatus(
          name: achievement.name,
          displayName: achievement.displayName,
          description: achievement.description,
          icon: isAchieved ? achievement.icon : achievement.iconGray,
          isAchieved: isAchieved,
        );
      }).toList();

      // 상태 업데이트
      state = state.copyWith(
        gameDataState: state.gameDataState.copyWith(
          schema: schemaResponse.game,
          achievements: mergedAchievements,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: state.loadingState.copyWith(
          description: "Failed to load game details: $e",
        ),
      );
    }
  }

  /// 게임 확장 상태 토글
  void toggleExpandedState(int appId) {
    final currentExpandedState = state.gameDataState.expandedState;
    final isExpanded = currentExpandedState[appId] ?? false;

    state = state.copyWith(
      gameDataState: state.gameDataState.copyWith(
        expandedState: {
          ...currentExpandedState,
          appId: !isExpanded, // 토글 상태 업데이트
        },
      ),
    );
  }
}
