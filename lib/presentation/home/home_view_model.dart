import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState.initial());

  Future<void> loadHomeData() async {
    // Skip loading if already loaded to prevent redundant work
    if (state.isDataLoaded || state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      // Remove artificial delay for faster startup
      // await Future.delayed(const Duration(milliseconds: 500));
      
      // Load data immediately
      state = state.copyWith(
        isLoading: false,
        isDataLoaded: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class HomeState {
  final bool isLoading;
  final bool isDataLoaded;
  final String? error;

  HomeState({
    required this.isLoading,
    required this.isDataLoaded,
    this.error,
  });

  factory HomeState.initial() {
    return HomeState(
      isLoading: false,
      isDataLoaded: false,
      error: null,
    );
  }

  HomeState copyWith({
    bool? isLoading,
    bool? isDataLoaded,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isDataLoaded: isDataLoaded ?? this.isDataLoaded,
      error: error ?? this.error,
    );
  }
}
