import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steamplayground/api/models/player_summaries_response.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const PlayerCard({super.key, required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
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
              Image.network(player.avatarFull),
              const SizedBox(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
