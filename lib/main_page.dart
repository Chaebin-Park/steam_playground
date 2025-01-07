import 'package:flutter/material.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/models/schema_for_game_response.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_achievements_usecase.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';
import 'package:steamplayground/api/usecase/resolve_vanity_url_usecase.dart';
import 'package:steamplayground/api/usecase/schema_for_game_usecase.dart';

class MainPage extends StatefulWidget {
  final String apiKey;

  const MainPage({super.key, required this.apiKey});

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  late final ApiClient _apiClient;
  late final SteamRepositoryImpl _repository;
  late final PlayerSummariesUseCase _getPlayerSummariesUseCase;
  late final ResolveVanityURLUseCase _resolveVanityURLUseCase;
  late final PlayerAchievementsUseCase _playerAchievementsUseCase;
  late final SchemaForGameUseCase _schemaForGameUseCase;
  late final OwnedGamesUseCase _ownedGamesUseCase;
  final TextEditingController _controller = TextEditingController();
  final Set<Player> _playerSet = {};
  final Set<OwnedGame> _games = {};
  final Map<int, SchemaGame> _gameSchema = {};
  final Map<int, bool> expandedState = {};
  String _steamId = "";
  String _errorMessage = "";

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: [top(), body()],
  //       ),
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 상단 로고
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: top(),
            ),
          ),
          // 검색 필드
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: search(),
            ),
          ),
          // 플레이어 목록
          if (_playerSet.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: playerList(),
              ),
            ),
          // 게임 리스트
          if (_games.isNotEmpty)
            gameList(),
          // 하단 텍스트
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text("Bottom"),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget top() {
    return Row(
      children: [
        Image.asset(
          'assets/images/img_steam_logo_black.png',
          width: 250,
          fit: BoxFit.fill,
        ),
      ],
    );
  }

  Widget body() {
    return Column(
      children: [
        const SizedBox(height: 16),
        search(),
        const SizedBox(height: 16),
        if (_playerSet.isNotEmpty) playerList(),
        const SizedBox(height: 16),
        if (_games.isNotEmpty) gameList(),
        const SizedBox(
          height: 16,
        ),
        Text("Bottom")
      ],
    );
  }

  String getSteamImageUrl(int appId, String imageHash) {
    return 'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/header.jpg';
  }

  Widget gameList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final isExpanded = expandedState[index] ?? false;
          final game = _games.elementAt(index);
          final achievements =
              _gameSchema[game.appId]?.availableGameStats.achievements ??
                  List.empty();

          return Container(
            margin:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expandedState[index] = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Image.network(
                        getSteamImageUrl(game.appId, game.imgIconUrl),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          game.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more),
                    ],
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Achievements: ${achievements.length}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        childCount: _games.length,
      ),
    );
  }


  // Widget gameList() {
  //   final Map<int, bool> expandedState = {};
  //
  //   return ListView.builder(
  //       itemCount: _games.length,
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         final isExpanded = expandedState[index] ?? false;
  //         final game = _games.elementAt(index);
  //         final achievements = _gameSchema[game.appId]?.availableGameStats.achievements ?? List.empty();
  //
  //         for (var ach in achievements) {
  //           print("${ach.name}  ${ach.displayName}  ${ach.description}  ${ach.icon}");
  //         }
  //
  //         return GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               expandedState[index] = !isExpanded;
  //             });
  //             _fetchGameSchema(game.appId);
  //           },
  //           child: Container(
  //             margin: const EdgeInsets.all(8),
  //             child: Row(
  //               children: [
  //                 Image.network(getSteamImageUrl(game.appId, game.imgIconUrl)),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         game.name,
  //                         style: const TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold),
  //                       ),
  //                       if (achievements.isNotEmpty)
  //                         ListView.builder(itemBuilder: (context, index) {
  //                           SchemaAchievement achievement = achievements[index];
  //                           return SizedBox(
  //                             height: 200,
  //                             child: Row(
  //                               children: [
  //                                 // Image.network(achievement.icon),
  //                                 Text(achievement.displayName),
  //                                 Text(achievement.description)
  //                               ],
  //                             ),
  //                           );
  //                         })
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget playerList() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _playerSet.length,
        itemBuilder: (context, index) {
          final player = _playerSet.elementAt(index);
          return GestureDetector(
            onTap: () {
              _handleFetchOwnedGames(player.steamId);
              setState(() {
                _steamId = player.steamId;
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.all(8),
              child: Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(player.avatarFull),
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          player.personaName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget search() {
    return Column(children: [
      TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Enter Steam Profile URL',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _handelFetchPlayerSummaries,
        child: const Text('Fetch Data'),
      ),
      if (_errorMessage.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
    ]);
  }

  Future<void> _fetchGameSchema(int appId) async {
    try {
      final response = await _schemaForGameUseCase.execute(
          {'key': widget.apiKey, 'appid': appId});
      final game = response.game;
      print("${game.gameName}, ${game.gameVersion}, ${game.availableGameStats
          .achievements.length}");
      setState(() {
        _gameSchema[appId] = game;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<String?> _fetchSteamIdFromVanityUrl(String vanityUrl) async {
    try {
      final response = await _resolveVanityURLUseCase
          .execute({'key': widget.apiKey, 'vanityurl': vanityUrl});

      final data = response.response;
      if (data.success == 1) {
        return data.steamid; // Steam ID 반환
      } else {
        throw Exception('Vanity URL not resolved: ${data.success}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
    return null;
  }

  Future<void> _handleFetchOwnedGames(String steamId) async {
    try {
      final response = await _ownedGamesUseCase.execute({
        'key': widget.apiKey,
        'steamid': steamId,
      });

      final List<int> importantGames = _games
          .where((game) => game.playtimeForever > 600)
          .map<int>((game) => game.appId)
          .toSet()
          .toList();

      setState(() {
        _games.clear();
        _games.addAll(response.response.games);
      });
    } catch (e) {
      setState(() {
        _errorMessage = "owned games error: ${e.toString()}";
        print(e);
      });
    }
  }

  Future<void> _handelFetchPlayerSummaries() async {
    final url = _controller.text;
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
      final response = await _getPlayerSummariesUseCase.execute({
        'key': widget.apiKey,
        'steamids': steamId,
      });
      final player = response.response.players.first;

      setState(() {
        _playerSet.add(player);
        _errorMessage = "";
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
    _controller.clear();
  }
}
