import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/network/api_client.dart';
import '../../../../../common/network/api_endpoints.dart';
import '../../models/skin_concern_model.dart';

final recommendationRemoteDataSourceProvider =
    Provider<RecommendationRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return RecommendationRemoteDataSource(client);
});

class RecommendationRemoteDataSource {
  final ApiClient _client;

  RecommendationRemoteDataSource(this._client);

  Future<List<SkinConcernModel>> fetchSkinConcerns() async {
    final dynamic response = await _client.get(ApiEndpoints.skinConcerns);
    final List<dynamic> list = response is List ? response : (response['data'] ?? []);
    return list.map((item) => SkinConcernModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  Future<Map<String, dynamic>> getRecommendations(List<String> selectedConcerns) async {
    final Map<String, dynamic> response = await _client.post(
      ApiEndpoints.recommendations,
      body: {'concerns': selectedConcerns},
    );
    return response;
  }

  Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    await _client.post(ApiEndpoints.userProfile, body: profileData);
  }
}
