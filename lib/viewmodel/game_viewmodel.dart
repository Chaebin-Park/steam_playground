import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
import 'package:steamplayground/api/param/player_archievements_params.dart';
import 'package:steamplayground/api/param/schema_for_game_params.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';
import 'package:steamplayground/riverpod/combined_state.dart';

class GameViewModel extends StateNotifier<CombinedState> {
  final OwnedGamesUseCase ownedGamesUseCase;
  final PlayerAchievementsUseCase playerAchievementsUseCase;
  final SchemaForGameUseCase schemaForGameUseCase;

  GameViewModel({
    required this.ownedGamesUseCase,
    required this.playerAchievementsUseCase,
    required this.schemaForGameUseCase,
  }) : super(CombinedState());

  /// 게임 리스트 가져오기
  Future<void> fetchOwnedGames(String steamId) async {
    state = state.copyWith(
      loadingState: state.loadingState.copyWith(
        isLoading: true,
        description: "Fetching owned games...",
      ),
    );

    try {
      final response = await ownedGamesUseCase.execute(
        OwnedGamesParams(apiKey: 'YOUR_API_KEY', steamId: steamId),
      );

      final expandedState = List<bool>.filled(
          response.response.games.length, false);

      state = state.copyWith(
        gameDataState: state.gameDataState.copyWith(
          games: response.response.games,
          expandedState: expandedState,
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
    // 게임 확장 상태 변경
    final expandedState = List<bool>.from(state.gameDataState.expandedState);
    final isExpanded = expandedState[appId];
    expandedState[appId] = !isExpanded;

    state = state.copyWith(
      gameDataState: state.gameDataState.copyWith(
          expandedState: expandedState),
    );

    // 확장된 상태에서만 세부 정보 로드
    if (!isExpanded) {
      try {
        final schemaResponse = await schemaForGameUseCase.execute(
          SchemaForGameParams(apiKey: 'YOUR_API_KEY', appId: appId),
        );

        state = state.copyWith(
          gameDataState: state.gameDataState.copyWith(
            schema: schemaResponse.game, // 단일 schema 업데이트
          ),
        );
      } catch (e) {
        // 에러 처리
        state = state.copyWith(
          loadingState: state.loadingState.copyWith(
            description: "Failed to load game details: $e",
          ),
        );
      }
    }
  }

  /// 게임 확장 상태 토글
  void toggleExpandedState(int index) {
    final expandedState = List<bool>.from(state.gameDataState.expandedState);
    expandedState[index] = !expandedState[index];

    state = state.copyWith(
      gameDataState: state.gameDataState.copyWith(
        expandedState: expandedState,
      ),
    );
  }
}
