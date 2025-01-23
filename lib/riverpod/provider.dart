import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/repository/steam_repository.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';
import 'package:steamplayground/api/usecase/resolve_vanity_url_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';
import 'package:steamplayground/riverpod/combined_state.dart';
import 'package:steamplayground/riverpod/player_state.dart';
import 'package:steamplayground/viewmodel/game_viewmodel.dart';
import 'package:steamplayground/viewmodel/player_viewmodel.dart';

///api
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final steamRepositoryProvider = Provider<SteamRepository>((ref) {
  const functionsBaseUrl = "/api";
  return SteamRepositoryImpl(
    functionsBaseUrl: functionsBaseUrl, // functionsBaseUrl 추가
  );
});

/// Game
final ownedGamesUseCaseProvider = Provider<OwnedGamesUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  return OwnedGamesUseCase(repository: repository);
});

final playerAchievementsUseCaseProvider =
    Provider<PlayerAchievementsUseCase>((ref) {
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

/// Player
final playerSummariesUseCaseProvider = Provider<PlayerSummariesUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  // final apiKey = ref.read(apiKeyProvider);
  // return PlayerSummariesUseCase(repository: repository, apiKey: apiKey);
  return PlayerSummariesUseCase(repository: repository);
});

final resolveVanityURLUseCaseProvider =
    Provider<ResolveVanityURLUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  // final apiKey = ref.read(apiKeyProvider);
  // return ResolveVanityURLUseCase(repository: repository, apiKey: apiKey);
  return ResolveVanityURLUseCase(repository: repository);
});

final playerViewModelProvider =
    StateNotifierProvider<PlayerViewModel, PlayerState>((ref) {
  final playerSummariesUseCase = ref.read(playerSummariesUseCaseProvider);
  final resolveVanityURLUseCase = ref.read(resolveVanityURLUseCaseProvider);
  return PlayerViewModel(
    playerSummariesUseCase: playerSummariesUseCase,
    resolveVanityURLUseCase: resolveVanityURLUseCase,
  );
});
