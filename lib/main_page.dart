import 'package:flutter/material.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/owned_games_usecase.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';
import 'package:steamplayground/api/usecase/resolve_vanity_url_usecase.dart';

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
  late final OwnedGamesUseCase _ownedGamesUseCase;
  final TextEditingController _controller = TextEditingController();
  final Set<Player> _playerSet = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _repository = SteamRepositoryImpl(apiClient: _apiClient);
    _getPlayerSummariesUseCase =
        PlayerSummariesUseCase(repository: _repository);
    _resolveVanityURLUseCase = ResolveVanityURLUseCase(repository: _repository);
    _ownedGamesUseCase = OwnedGamesUseCase(repository: _repository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [top(), body()],
        ),
      ),
    ));
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
      ],
    );
  }

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
            onTap: () { _handleFetchOwnedGames(player.steamId); },
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
      if (_errorMessage != null)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
    ]);
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
        'include_appinfo': 2,
        'include_played_free_game': 1,
        'format': 'json'
      });

      print(response.response.games);
      setState(() {

      });
    } catch(e) {
      setState(() {
        _errorMessage = e.toString();
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
        print(steamId);
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
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
    _controller.clear();
  }
}
