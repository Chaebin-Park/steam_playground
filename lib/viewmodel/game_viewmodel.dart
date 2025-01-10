import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
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

      final expandedState =
          List<bool>.filled(response.response.games.length, false);

      state = state.copyWith(
        gameDataState: state.gameDataState.copyWith(
          games: response.response.games,
          expandedState: expandedState,
        ),
        loadingState: state.loadingState.copyWith(isLoading: false),
      );

      /**
      for (int i = 0; i < response.response.gameCount; i++) {
        OwnedGame game = response.response.games[i];

        state = state.copyWith(
          loadingState: state.loadingState.copyWith(
            isLoading: true,
            description: "${game.name} loading...",
            currentIndex: i,
            totalSteps: response.response.gameCount
          ),
        );
        await fetchGameDetails(steamId, game.appId);
      }
          **/

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
  Future<void> fetchGameDetails(int appId) async {
    // 게임 확장 상태 변경
    final expandedState = List<bool>.from(state.gameDataState.expandedState);
    final isExpanded = expandedState[appId];
    expandedState[appId] = !isExpanded;

    state = state.copyWith(
      gameDataState: state.gameDataState.copyWith(expandedState: expandedState),
    );

    // 확장된 상태에서만 세부 정보 로드
    if (!isExpanded) {
      try {
        final schemaResponse = await _schemaForGameUseCase.execute(
          SchemaForGameParams(appId: appId),
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

    if (index >= expandedState.length) {
      expandedState.addAll(List<bool>.filled(index - expandedState.length + 1, false));
    }

    expandedState[index] = !expandedState[index];

    state = state.copyWith(
      gameDataState: state.gameDataState.copyWith(
        expandedState: expandedState,
      ),
    );
  }
}
