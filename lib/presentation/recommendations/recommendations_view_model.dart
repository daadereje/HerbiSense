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
  final bool isLoading;
  final String? error;

  RecommendationsState({
    required this.currentStep,
    required this.skinConcerns,
    required this.isLoading,
    this.error,
  });

  factory RecommendationsState.initial() {
    return RecommendationsState(
      currentStep: 1,
      skinConcerns: SkinConcernModel.getMockConcerns(),
      isLoading: false,
      error: null,
    );
  }

  bool get hasSelection => skinConcerns.any((concern) => concern.selected);

  RecommendationsState copyWith({
    int? currentStep,
    List<SkinConcernModel>? skinConcerns,
    bool? isLoading,
    String? error,
  }) {
    return RecommendationsState(
      currentStep: currentStep ?? this.currentStep,
      skinConcerns: skinConcerns ?? this.skinConcerns,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
