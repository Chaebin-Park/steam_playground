import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';
import 'package:steamplayground/api/param/owned_games_params.dart';
import 'package:steamplayground/api/param/player_archievements_params.dart';
import 'package:steamplayground/api/param/player_summaries_params.dart';
import 'package:steamplayground/api/param/resolve_vanity_url_params.dart';
import 'package:steamplayground/api/param/schema_for_game_params.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';
import 'package:steamplayground/api/usecase/resolve_vanity_url_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';
import 'package:steamplayground/widget/game_list.dart';
import 'package:steamplayground/widget/loading_overlay.dart';
import 'package:steamplayground/widget/player_list.dart';
import 'package:steamplayground/widget/search_widget.dart';

class MainPage extends ConsumerStatefulWidget {
  final String apiKey;

  const MainPage({super.key, required this.apiKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPage();
}

class _MainPage extends ConsumerState<MainPage> {
  late final ApiClient _apiClient;
  late final SteamRepositoryImpl _repository;
  late final PlayerSummariesUseCase _getPlayerSummariesUseCase;
  late final ResolveVanityURLUseCase _resolveVanityURLUseCase;
  late final PlayerAchievementsUseCase _playerAchievementsUseCase;
  late final SchemaForGameUseCase _schemaForGameUseCase;
  late final OwnedGamesUseCase _ownedGamesUseCase;
  final Set<Player> _playerSet = {};
  final Set<OwnedGame> _games = {};
  final Map<int, Map<String, int>> _playerAchievement = {};
  final Map<int, GameSchema> _gameSchema = {};
  Map<int, bool> _expandedState = {};
  String _steamId = "";
  bool _isLoading = false;
  int _currentIndex = 0;
  int _totalSteps = 0;
  String _loadingDescription = "";

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _repository = SteamRepositoryImpl(apiClient: _apiClient);
    _getPlayerSummariesUseCase =
        PlayerSummariesUseCase(repository: _repository);
    _resolveVanityURLUseCase = ResolveVanityURLUseCase(repository: _repository);
    _ownedGamesUseCase = OwnedGamesUseCase(repository: _repository);
    _playerAchievementsUseCase =
        PlayerAchievementsUseCase(repository: _repository);
    _schemaForGameUseCase = SchemaForGameUseCase(repository: _repository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 실제 콘텐츠
          CustomScrollView(
            slivers: [
              top(),
              search(),
              if (_playerSet.isNotEmpty) playerList(),
              if (_games.isNotEmpty) gameList(),
            ],
          ),
          // 로딩 팝업
          if (_isLoading)
            LoadingOverlay(
                isLoading: _isLoading,
                description: _loadingDescription,
                currentIndex: _currentIndex,
                totalSteps: _totalSteps)
        ],
      ),
    );
  }

  Widget top() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/img_steam_logo_black.png',
              width: 250,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  String getSteamImageUrl(int appId) {
    return 'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/header.jpg';
  }

  Widget gameList() {
    /**
    return GameList(
        games: _games.toList(),
        expandedState: _expandedState,
        gameSchema: _gameSchema,
        onItemClick: (index) {
          setState(() {
            _expandedState[index] = !(_expandedState[index] ?? false);
          });
        });
        **/
    return GameList();
  }

  Widget playerList() {
    return PlayerList(
      players: _playerSet,
      currentSteamId: _steamId,
      onPlayerSelected: (steamId) async {
        await _handleFetchOwnedGames(steamId);
        setState(() {
          if (steamId != _steamId) {
            _expandedState.clear();
          }
          _steamId = steamId;
        });
      },
    );
  }

  Widget search() {
    return SearchWidget(onPressed: (url) async {
      await _handelFetchPlayerSummaries(url);
    });
  }

  Future<void> _fetchGameSchema(int appId) async {
    try {
      final response = await _schemaForGameUseCase
          .execute(SchemaForGameParams(apiKey: widget.apiKey, appId: appId));

      final game = response.game;
      setState(() {
        _gameSchema[appId] = game;
      });
    } catch (e) {
      print("fetch game schema: ${e.toString()}");
    }
  }

  Future<String?> _fetchSteamIdFromVanityUrl(String vanityUrl) async {
    try {
      final response = await _resolveVanityURLUseCase.execute(
          ResolveVanityURLParams(apiKey: widget.apiKey, vanityUrl: vanityUrl));

      final data = response.response;
      if (data.success == 1) {
        return data.steamid; // Steam ID 반환
      } else {
        throw Exception('Vanity URL not resolved: ${data.success}');
      }
    } catch (e) {
      print("fetch steamId from vanity url : ${e.toString()}");
    }
    return null;
  }

  Future<void> _handleFetchPlayerAchievements(String steamId, int appId) async {
    try {
      final response = await _playerAchievementsUseCase.execute(
          PlayerAchievementsParams(
              apiKey: widget.apiKey, steamId: steamId, appId: appId));

      Map<String, int> achievementMap = {
        for (var achievement in response.playerStats.achievements)
          achievement.apiName: achievement.achieved
      };

      setState(() {
        _playerAchievement[appId] = achievementMap;
      });
    } catch (e) {
      print("player achievements: ${e.toString()}");
    }
  }

  Future<void> _handleFetchOwnedGames(String steamId) async {
    setState(() {
      _isLoading = true;
      _currentIndex = 0;
      _totalSteps = 0;
    });

    try {
      final response = await _ownedGamesUseCase
          .execute(OwnedGamesParams(apiKey: widget.apiKey, steamId: steamId));

      final Set<OwnedGame> importantGames = response.response.games
          .where((game) => game.playtimeForever > 600)
          .map<OwnedGame>((game) => game)
          .toSet();

      setState(() {
        _totalSteps = importantGames.length;
      });

      List<Future<void>> tasks = [];
      int completedTasks = 0;

      for (var game in importantGames) {
        tasks.add(Future(() async {
          await _handleFetchPlayerAchievements(steamId, game.appId);
          await _fetchGameSchema(game.appId);

          // 진행 상황 업데이트
          setState(() {
            completedTasks++;
            _currentIndex = completedTasks;
            _loadingDescription = "Find ${game.name} achievements...";
          });
        }));
      }

      // 병렬 작업이 모두 완료될 때까지 대기
      await Future.wait(tasks);

      setState(() {
        _expandedState = {
          for (int i = 0; i < _games.length; i++) i: false,
        };
        _games.clear();
        _games.addAll(importantGames);
      });
    } catch (e) {
      print("owned games error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handelFetchPlayerSummaries(String url) async {
    String? steamId;
    if (url.contains('/profiles/')) {
      // Steam ID가 URL에 포함된 경우
      final regex = RegExp(r'profiles/(\d+)/?');
      final match = regex.firstMatch(url);
      if (match != null) {
        steamId = match.group(1);
      }
    } else if (url.contains('/id/')) {
      // 커스텀 URL의 경우 ResolveVanityURL API 호출
      final regex = RegExp(r'id/([^/]+)/?');
      final match = regex.firstMatch(url);
      if (match != null) {
        final vanityUrl = match.group(1);
        steamId = await _fetchSteamIdFromVanityUrl(vanityUrl!);
      }
    }

    try {
      final response = await _getPlayerSummariesUseCase.execute(
          PlayerSummariesParams(
              apiKey: widget.apiKey, steamId: steamId.toString()));
      final player = response.response.players.first;

      setState(() {
        _playerSet.add(player);
      });
    } catch (e) {
      print("fetch player summary: ${e.toString()}");
    }
  }
}
