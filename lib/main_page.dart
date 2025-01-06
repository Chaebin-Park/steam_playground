import 'package:flutter/material.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';

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
        if (_playerSet.isNotEmpty)
          playerList(),
        const SizedBox(height: 16),
        Text('Bottom')
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
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(children: [
              Image.network(player.avatarfull),
              Center(
                child: Text(
                  player.personaname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
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

  String? _extractSteamId(String url) {
    final regex = RegExp(r'https:\/\/steamcommunity\.com\/profiles\/(\d+)\/?');
    final match = regex.firstMatch(url);

    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  Future<void> _handelFetchPlayerSummaries() async {
    final inputUrl = _controller.text;
    final steamId = _extractSteamId(inputUrl);

    if (steamId == null) {
      setState(() {
        _errorMessage = 'Invalid Steam Profile URL';
      });
      return;
    }

    try {
      final response = await _getPlayerSummariesUseCase.execute({
        'key': widget.apiKey,
        'steamids': steamId,
      });
      final player = response.response.players.first;

      setState(() {
        // playerset contain check
        _playerSet.add(player);
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

/**
    Future<PlayerSummariesResponse> _fetchData(List<String> steamIds) async {
    try {
    final result = await _getPlayerSummariesUseCase.execute({
    'key': widget.apiKey,
    'steamids': steamIds,
    });

    return PlayerSummariesResponse.fromJson(result);
    } catch (e) {
    throw Exception('Error: $e');
    }
    }
 **/
}
