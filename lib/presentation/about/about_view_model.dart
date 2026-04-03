import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/data/models/about_stat_model.dart';
import '../../core/constants/data/repositories/about_repository.dart';

final aboutViewModelProvider = StateNotifierProvider<AboutViewModel, AboutState>((ref) {
  final repository = ref.watch(aboutRepositoryProvider);
  return AboutViewModel(repository);
});

class AboutViewModel extends StateNotifier<AboutState> {
  final AboutRepository _repository;

  AboutViewModel(this._repository) : super(AboutState.initial());

  Future<void> loadAboutData() async {
    state = state.copyWith(isLoading: true);
    try {
      final stats = await _repository.getAboutStats();
      state = state.copyWith(
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class AboutState {
  final List<AboutStatModel> stats;
  final bool isLoading;
  final String? error;

  AboutState({
    required this.stats,
    required this.isLoading,
    this.error,
  });

  factory AboutState.initial() {
    return AboutState(
      stats: AboutStatModel.getMockStats(),
      isLoading: false,
      error: null,
    );
  }

  AboutState copyWith({
    List<AboutStatModel>? stats,
    bool? isLoading,
    String? error,
  }) {
    return AboutState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
