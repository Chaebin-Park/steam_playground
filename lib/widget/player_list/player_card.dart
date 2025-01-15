import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final VoidCallback onTap;

  const PlayerCard(
      {super.key,
      required this.player,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blue[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(8),
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                player.avatarFull,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/img_steam_logo_black.png'); // 기본 아바타 이미지
                },
              ),
              const SizedBox(
                height: 8,
              ),
              _buildPlayerName(player.personaName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerName(String name) {
    return Text(
      name,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }
}
