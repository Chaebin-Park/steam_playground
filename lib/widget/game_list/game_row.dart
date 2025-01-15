import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/achievement_with_status.dart';
import 'package:steamplayground/api/models/owned_games_response.dart';
import 'package:steamplayground/widget/game_list/achievement_row.dart';
import 'dart:math' as math;

class GameRow extends StatelessWidget {
  final OwnedGame game;
  final List<AchievementWithStatus> achievements;

  const GameRow({
    super.key,
    required this.game,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    double imageWidth = math.min(
      MediaQuery.of(context).size.width * 0.3,
      200,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildGameImage(imageWidth),
          const SizedBox(width: 16),
          _buildGameInfo(),
        ],
      ),
    );
  }

  /// 게임 이미지 섹션
  Widget _buildGameImage(double imageWidth) {
    return Flexible(
      flex: 1,
      child: SizedBox(
        width: imageWidth,
        child: Image.network(
          'https://cdn.cloudflare.steamstatic.com/steam/apps/${game.appId}/header.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/img_steam_logo_black.png', // 기본 이미지
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  /// 게임 정보 섹션
  Widget _buildGameInfo() {
    return Flexible(
      flex: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameTitle(),
          const SizedBox(height: 8),
          AchievementsRow(achievements: achievements),
        ],
      ),
    );
  }

  /// 게임 제목과 플레이 시간
  Widget _buildGameTitle() {
    return Row(
      children: [
        Text(
          game.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          calcPlayTime(game.playtimeForever),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// 플레이 시간을 계산하는 함수
  String calcPlayTime(int playtimeMinutes) {
    int hours = playtimeMinutes ~/ 60;
    int minutes = playtimeMinutes % 60;

    return "$hours h $minutes m";
  }
}
