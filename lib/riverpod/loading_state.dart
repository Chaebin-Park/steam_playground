class LoadingState {
  final bool isLoading;
  final String description;
  final int currentIndex;
  final int totalSteps;

  const LoadingState({
    this.isLoading = false,
    this.description = '',
    this.currentIndex = 0,
    this.totalSteps = 0,
  });

  LoadingState copyWith({
    bool? isLoading,
    String? description,
    int? currentIndex,
    int? totalSteps,
  }) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      description: description ?? this.description,
      currentIndex: currentIndex ?? this.currentIndex,
      totalSteps: totalSteps ?? this.totalSteps,
    );
  }
}
