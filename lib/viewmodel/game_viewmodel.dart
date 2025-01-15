import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
import 'package:steamplayground/api/param/player_archievements_params.dart';
import 'package:steamplayground/api/param/schema_for_game_params.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';
import 'package:steamplayground/riverpod/combined_state.dart';
import 'package:steamplayground/riverpod/drawer_state.dart';

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

      final Set<OwnedGame> importantGames = response.response.games
          .where((game) => game.playtimeForever > 0)
          .map<OwnedGame>((game) => game)
          .toSet();
      final Map<int, bool> expandedState = {};

      List<Future<void>> tasks = [];
      int completedTasks = 0;
      for (int i = 0; i < importantGames.length; i++) {
        tasks.add(Future(() async {
          OwnedGame game = importantGames.elementAt(i);
          await _fetchGameDetails(steamId, game.appId);
          completedTasks++;
          expandedState[game.appId] = false;
          state = state.copyWith(
            loadingState: state.loadingState.copyWith(
                isLoading: true,
                description: "Fetching ${game.name}...",
                currentIndex: completedTasks,
                totalSteps: importantGames.length),
          );
        }));
      }
      await Future.wait(tasks);

      state = state.copyWith(
        gameDataState: state.gameDataState.copyWith(
          games: importantGames.toList(),
          expandedState: expandedState,
        ),
        loadingState: state.loadingState.copyWith(isLoading: false),
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: state.loadingState.copyWith(
          isLoading: false,
          description: "Failed to fetch owned games",
          currentIndex: 0,
          totalSteps: 0
        ),
      );
    } finally {
      state = state.copyWith(
        loadingState: state.loadingState.copyWith(
            isLoading: false,
            description: "Fetch owned games",
            currentIndex: 0,
            totalSteps: 0
        ),
      );
    }
  }

  /// 게임 세부 정보 가져오기
  Future<void> _fetchGameDetails(String steamId, int appId) async {
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
          achievements: {
            ...state.gameDataState.achievements,
            appId: mergedAchievements, // appId 기준으로 저장
          },
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

  void openDrawer(List<AchievementWithStatus> achievements) {
    state = state.copyWith(drawerState: DrawerState(
      isExpanded: true,
      achievements: achievements
    ));
  }

  void closeDrawer() {
    state = state.copyWith(drawerState: DrawerState(
        isExpanded: false
    ));
  }
}
