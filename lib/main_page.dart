import 'package:flutter/material.dart';
import 'package:steamplayground/api/api_client.dart';
import 'package:steamplayground/api/repository/steam_repository_impl.dart';
import 'package:steamplayground/api/usecase/player_summaries_usecase.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  late final ApiClient _apiClient;
  late final SteamRepositoryImpl _repository;
  late final PlayerSummariesUseCase _getPlayerSummariesUseCase;
  String _apiResult = "Press the button to fetch data";

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _repository = SteamRepositoryImpl(apiClient: _apiClient);
    _getPlayerSummariesUseCase = PlayerSummariesUseCase(repository: _repository);
  }

  Future<void> _fetchData() async {
    const apiKey = '17F9334D45AC9974227CC471FDD0B8AC'; // Replace with your API key
    final steamIds = ["76561198064110324", "76561198112250619"]; // Replace with Steam IDs

    try {
      final result = await _getPlayerSummariesUseCase.execute({
        'key': apiKey,
        'steamids': steamIds,
      });
      setState(() {
        _apiResult = result.toString();
      });
    } catch (e) {
      setState(() {
        _apiResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _fetchData,
            child: const Text("Fetch Player Summaries"),
          ),
          const SizedBox(height: 20),
          Text(
            _apiResult,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}