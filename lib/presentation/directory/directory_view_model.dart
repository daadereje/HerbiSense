import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/data/models/herb_model.dart';
import '../../core/constants/data/repositories/herb_repository.dart';

final directoryViewModelProvider = StateNotifierProvider<DirectoryViewModel, DirectoryState>((ref) {
  final herbRepository = ref.watch(herbRepositoryProvider);
  return DirectoryViewModel(herbRepository);
});

class DirectoryViewModel extends StateNotifier<DirectoryState> {
  final HerbRepository _herbRepository;

  DirectoryViewModel(this._herbRepository) : super(DirectoryState.initial());

  Future<void> loadHerbs(String language) async {
    state = state.copyWith(isLoading: true);
    try {
      final herbs = await _herbRepository.getAllHerbs(language: language);
      state = state.copyWith(
        allHerbs: herbs,
        filteredHerbs: herbs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void setSelectedCondition(String condition) {
    state = state.copyWith(selectedCondition: condition);
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<HerbModel>.from(state.allHerbs);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((herb) {
        return herb.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            herb.scientificName.toLowerCase().contains(state.searchQuery.toLowerCase());
      }).toList();
    }

    // Apply condition filter
    if (state.selectedCondition != 'All Conditions') {
      filtered = filtered.where((herb) {
        return herb.skinConditions.contains(state.selectedCondition);
      }).toList();
    }

    state = state.copyWith(filteredHerbs: filtered);
  }
}

class DirectoryState {
  final List<HerbModel> allHerbs;
  final List<HerbModel> filteredHerbs;
  final String searchQuery;
  final String selectedCondition;
  final bool isLoading;
  final String? error;
  final String lastSync;
  final int totalHerbs;
  final int publishedCount;

  DirectoryState({
    required this.allHerbs,
    required this.filteredHerbs,
    required this.searchQuery,
    required this.selectedCondition,
    required this.isLoading,
    this.error,
    required this.lastSync,
    required this.totalHerbs,
    required this.publishedCount,
  });

  factory DirectoryState.initial() {
    return DirectoryState(
      allHerbs: [],
      filteredHerbs: [],
      searchQuery: '',
      selectedCondition: 'All Conditions',
      isLoading: false,
      error: null,
      lastSync: '3/6/2026',
      totalHerbs: 3,
      publishedCount: 3,
    );
  }

  DirectoryState copyWith({
    List<HerbModel>? allHerbs,
    List<HerbModel>? filteredHerbs,
    String? searchQuery,
    String? selectedCondition,
    bool? isLoading,
    String? error,
    String? lastSync,
    int? totalHerbs,
    int? publishedCount,
  }) {
    return DirectoryState(
      allHerbs: allHerbs ?? this.allHerbs,
      filteredHerbs: filteredHerbs ?? this.filteredHerbs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastSync: lastSync ?? this.lastSync,
      totalHerbs: totalHerbs ?? this.totalHerbs,
      publishedCount: publishedCount ?? this.publishedCount,
    );
  }
}
