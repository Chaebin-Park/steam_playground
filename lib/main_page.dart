import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';
import 'package:steamplayground/widget/drawer_widget.dart';
import 'package:steamplayground/widget/game_list/game_list.dart';
import 'package:steamplayground/widget/loading_overlay.dart';
import 'package:steamplayground/widget/player_list/player_list.dart';
import 'package:steamplayground/widget/search_widget.dart';
import 'package:steamplayground/widget/top_widget.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart'; // Player 클래스 경로
import 'main.dart'; // IndexedDB 전역 변수 경로

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    _loadPlayersFromDB();
  }

  Future<void> _loadPlayersFromDB() async {
    final dbData = await playerDB.getAll();
    final players = dbData.map((json) => Player.fromJson(json)).toSet();

    for (var player in players) {
      print("player: $player");
    }

    ref.read(playerViewModelProvider.notifier).updatePlayers(players);
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerViewModelProvider);
    final gameState = ref.watch(gameViewModelProvider);

    final bool playerListChecker = playerState.players.isNotEmpty;
    final bool gameListChecker = gameState.gameDataState.games.isNotEmpty;
    final double drawerWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width -
                (gameState.drawerState.isExpanded ? drawerWidth / 2 : 0),
            height: MediaQuery.of(context).size.height,
            child: CustomScrollView(
              slivers: [
                TopWidget(),
                const SearchWidget(),
                if (playerListChecker) PlayerList(),
                if (gameListChecker) GameList(),
              ],
            ),
          ),
          DrawerWidget(width: drawerWidth),
          if (gameState.loadingState.isLoading)
            LoadingOverlay(
              loadingState: gameState.loadingState,
            ),
        ],
      ),
    );
  }
}
