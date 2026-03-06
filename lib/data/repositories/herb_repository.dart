import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/herb_model.dart';

final herbRepositoryProvider = Provider<HerbRepository>((ref) {
  return HerbRepository();
});

class HerbRepository {
  // This will be replaced with actual API/database calls later
  Future<List<HerbModel>> getAllHerbs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return HerbModel.getMockHerbs();
  }

  Future<HerbModel?> getHerbById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return HerbModel.getMockHerbs().firstWhere((herb) => herb.id == id);
  }

  Future<List<HerbModel>> searchHerbs(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return HerbModel.getMockHerbs();

    return HerbModel.getMockHerbs().where((herb) {
      return herb.name.toLowerCase().contains(query.toLowerCase()) ||
          herb.scientificName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<List<HerbModel>> getHerbsByCondition(String condition) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (condition == 'All Conditions') return HerbModel.getMockHerbs();

    return HerbModel.getMockHerbs().where((herb) {
      return herb.skinConditions.contains(condition);
    }).toList();
  }
}
