import 'package:flutter/material.dart';

class AchievementProgressBar extends StatelessWidget {
  final double rate;
  final double circularRadius = 5;

  const AchievementProgressBar({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(circularRadius),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: rate,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(circularRadius),
              ),
            ),
          ),
          Center(
            child: Text(
              "${(rate * 100).toStringAsFixed(2)} %",
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}