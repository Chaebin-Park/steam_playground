import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';

class GameState extends StateNotifier<Set<OwnedGame>> {
  GameState() : super({});

  void setGames(Set<OwnedGame> games) => state = games;
  void clearGames() => state = {};
}