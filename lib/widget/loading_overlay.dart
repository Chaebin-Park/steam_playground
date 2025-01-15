import 'package:flutter/material.dart';
import 'package:steamplayground/riverpod/loading_state.dart';

class LoadingOverlay extends StatelessWidget {
  final LoadingState loadingState;

  const LoadingOverlay(
      {super.key,
      required this.loadingState});

  @override
  Widget build(BuildContext context) {
    if (!loadingState.isLoading) {
      return
        const SizedBox.shrink();
    }

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
          "${loadingState.description} (${loadingState.currentIndex} / ${loadingState.totalSteps})",
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
                widthFactor: loadingState.totalSteps > 0 ? loadingState.currentIndex / loadingState.totalSteps : 0,
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
