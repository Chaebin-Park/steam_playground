class LoadingState {
  final bool isLoading;
  final String description;

  LoadingState({
    this.isLoading = false,
    this.description = "",
  });

  LoadingState copyWith({
    bool? isLoading,
    String? description,
  }) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      description: description ?? this.description,
    );
  }
}