import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String description;
  final int currentIndex;
  final int totalSteps;

  const LoadingOverlay(
      {super.key,
      required this.isLoading,
      required this.description,
      required this.currentIndex,
      required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return SizedBox.shrink();

    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withAlpha(50),
        ),
        Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: _loadingContent(),
          ),
        )
      ],
    );
  }

  Widget _loadingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$description ($currentIndex / $totalSteps)",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: totalSteps > 0 ? currentIndex / totalSteps : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
