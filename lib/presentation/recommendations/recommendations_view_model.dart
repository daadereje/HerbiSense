import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/skin_concern_model.dart';
import '../../data/repositories/recommendation_repository.dart';
import 'widgets/severity_bottom_sheet.dart';

final recommendationsViewModelProvider =
    StateNotifierProvider<RecommendationsViewModel, RecommendationsState>((ref) {
  final repository = ref.watch(recommendationRepositoryProvider);
  return RecommendationsViewModel(repository);
});

class RecommendationsViewModel extends StateNotifier<RecommendationsState> {
  final RecommendationRepository _repository;

  RecommendationsViewModel(this._repository) : super(RecommendationsState.initial());

  Future<void> loadSkinConcerns() async {
    state = state.copyWith(isLoading: true);
    try {
      final concerns = await _repository.getSkinConcerns();
      state = state.copyWith(isLoading: false, skinConcerns: concerns);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void showSeverityDialog(BuildContext context, int index) {
    if (!state.skinConcerns[index].selected) {
      _toggleConcernSelection(index, true);
    }

    _showSeverityBottomSheet(context, index);
  }

  void _showSeverityBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SeverityBottomSheet(
          concern: state.skinConcerns[index],
          onSeveritySelected: (level) {
            _setSeverityLevel(index, level);
          },
        );
      },
    );
  }

  void _toggleConcernSelection(int index, bool selected) {
    final updatedConcerns = List<SkinConcernModel>.from(state.skinConcerns);
    updatedConcerns[index] = updatedConcerns[index].copyWith(selected: selected);
    state = state.copyWith(skinConcerns: updatedConcerns);
  }

  void _setSeverityLevel(int index, int level) {
    final updatedConcerns = List<SkinConcernModel>.from(state.skinConcerns);
    updatedConcerns[index] = updatedConcerns[index].copyWith(
      selected: true,
      severity: level,
    );
    state = state.copyWith(skinConcerns: updatedConcerns);
  }

  Future<void> searchConditions(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: [], searchError: null);
      return;
    }

    state = state.copyWith(isSearchLoading: true, searchError: null);
    try {
      final results = await _repository.searchConditions(query);
      state = state.copyWith(
        isSearchLoading: false,
        searchResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isSearchLoading: false,
        searchError: e.toString(),
      );
    }
  }

  void selectConditionFromSearch(SkinConcernModel concern) {
    final updated = List<SkinConcernModel>.from(state.skinConcerns);
    final index = updated.indexWhere(
      (c) =>
          (c.id != null && c.id == concern.id) ||
          c.title.toLowerCase() == concern.title.toLowerCase(),
    );
    if (index >= 0) {
      updated[index] = updated[index].copyWith(
        selected: true,
        severity: updated[index].severity > 0 ? updated[index].severity : 1,
      );
    } else {
      updated.add(concern.copyWith(selected: true, severity: 1));
    }
    state = state.copyWith(
      skinConcerns: updated,
      searchResults: const [],
      isSearchLoading: false,
    );
  }

  void continueToNextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void goToPreviousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}

class RecommendationsState {
  final int currentStep;
  final List<SkinConcernModel> skinConcerns;
  final List<SkinConcernModel> searchResults;
  final bool isLoading;
  final bool isSearchLoading;
  final String? error;
  final String? searchError;

  RecommendationsState({
    required this.currentStep,
    required this.skinConcerns,
    required this.isLoading,
    required this.searchResults,
    required this.isSearchLoading,
    this.error,
    this.searchError,
  });

  factory RecommendationsState.initial() {
    return RecommendationsState(
      currentStep: 1,
      skinConcerns: SkinConcernModel.getMockConcerns(),
      isLoading: false,
      searchResults: const [],
      isSearchLoading: false,
      error: null,
      searchError: null,
    );
  }

  bool get hasSelection => skinConcerns.any((concern) => concern.selected);

  RecommendationsState copyWith({
    int? currentStep,
    List<SkinConcernModel>? skinConcerns,
    bool? isLoading,
    List<SkinConcernModel>? searchResults,
    bool? isSearchLoading,
    String? error,
    String? searchError,
  }) {
    return RecommendationsState(
      currentStep: currentStep ?? this.currentStep,
      skinConcerns: skinConcerns ?? this.skinConcerns,
      isLoading: isLoading ?? this.isLoading,
      searchResults: searchResults ?? this.searchResults,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      error: error ?? this.error,
      searchError: searchError ?? this.searchError,
    );
  }
}
