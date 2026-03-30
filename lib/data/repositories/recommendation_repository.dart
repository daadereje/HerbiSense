import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/network/api_client.dart';
import '../../common/network/api_endpoints.dart';
import '../models/skin_concern_model.dart';

final recommendationRepositoryProvider =
    Provider<RecommendationRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return RecommendationRepository(apiClient);
});

class RecommendationRepository {
  RecommendationRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SkinConcernModel>> getSkinConcerns() async {
    final response = await _apiClient.get(ApiEndpoints.skinConcerns);
    final items = _unwrapList(response, 'data', fallbackKey: 'concerns');
    if (items.isEmpty) return SkinConcernModel.getMockConcerns();
    return items.map(SkinConcernModel.fromJson).toList();
  }

  Future<List<SkinConcernModel>> searchConditions(String query) async {
    final response = await _apiClient.get(
      ApiEndpoints.conditionSearch,
      queryParams: {'search': query},
    );
    final items = _unwrapList(response, 'data', fallbackKey: 'conditions');
    return items.map(SkinConcernModel.fromJson).toList();
  }

  Future<Map<String, dynamic>> getRecommendations(
    List<String> selectedConcerns,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.recommendations,
      body: {
        'concerns': selectedConcerns,
      },
    );

    return _unwrapMap(response);
  }

  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    await _apiClient.post(ApiEndpoints.userProfile, body: profileData);
  }

  List<Map<String, dynamic>> _unwrapList(
    dynamic response,
    String key, {
    String? fallbackKey,
  }) {
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }

    if (response is Map<String, dynamic>) {
      final data = response[key] ?? (fallbackKey != null ? response[fallbackKey] : null) ?? response['data'] ?? [];
      return List<Map<String, dynamic>>.from(data as List);
    }

    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _unwrapMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    return {'data': response};
  }
}
