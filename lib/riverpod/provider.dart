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


/// API

final apiKeyProvider = Provider<String>((ref) {
  return dotenv.env['API_KEY']!;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final steamRepositoryProvider = Provider<SteamRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SteamRepositoryImpl(apiClient: apiClient);
});

/// Game
final ownedGamesUseCaseProvider = Provider<OwnedGamesUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  final apiKey = ref.read(apiKeyProvider);

  return OwnedGamesUseCase(repository: repository, apiKey: apiKey);
});

final playerAchievementsUseCaseProvider = Provider<PlayerAchievementsUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  final apiKey = ref.read(apiKeyProvider);
  return PlayerAchievementsUseCase(repository: repository, apiKey: apiKey);
});

final schemaForGameUseCaseProvider = Provider<SchemaForGameUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  final apiKey = ref.read(apiKeyProvider);
  return SchemaForGameUseCase(repository: repository, apiKey: apiKey);
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
  final apiKey = ref.read(apiKeyProvider);
  return PlayerSummariesUseCase(repository: repository, apiKey: apiKey);
});

final resolveVanityURLUseCaseProvider = Provider<ResolveVanityURLUseCase>((ref) {
  final repository = ref.read(steamRepositoryProvider);
  final apiKey = ref.read(apiKeyProvider);
  return ResolveVanityURLUseCase(repository: repository, apiKey: apiKey);
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


