import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';
import 'package:steamplayground/riverpod/combined_state.dart';
import 'package:steamplayground/riverpod/game_state.dart';
import 'package:steamplayground/viewmodel/game_viewmodel.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final steamRepositoryProvider = Provider<SteamRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SteamRepositoryImpl(apiClient: apiClient);
});

final ownedGamesUseCaseProvider = Provider<OwnedGamesUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  return OwnedGamesUseCase(repository: repository);
});

final playerAchievementsUseCaseProvider = Provider<PlayerAchievementsUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  return PlayerAchievementsUseCase(repository: repository);
});

final schemaForGameUseCaseProvider = Provider<SchemaForGameUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  return SchemaForGameUseCase(repository: repository);
});

final gameViewModelProvider =
StateNotifierProvider<GameViewModel, CombinedState>((ref) {
  final ownedGamesUseCase = ref.read(ownedGamesUseCaseProvider);
  final playerAchievementsUseCase = ref.read(playerAchievementsUseCaseProvider);
  final schemaForGameUseCase = ref.read(schemaForGameUseCaseProvider);

  return GameViewModel(
    ownedGamesUseCase: ownedGamesUseCase,
    playerAchievementsUseCase: playerAchievementsUseCase,
    schemaForGameUseCase: schemaForGameUseCase,
  );
});
