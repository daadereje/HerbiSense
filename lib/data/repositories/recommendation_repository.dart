import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_concern_model.dart';

final recommendationRepositoryProvider = Provider<RecommendationRepository>((ref) {
  return RecommendationRepository();
});

class RecommendationRepository {
  Future<List<SkinConcernModel>> getSkinConcerns() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return SkinConcernModel.getMockConcerns();
  }

  Future<Map<String, dynamic>> getRecommendations(List<String> selectedConcerns) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return {
      'recommendations': [],
      'herbs': [],
    };
  }

  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return;
  }
}
