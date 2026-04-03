import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_endpoints.dart';
import '../models/about_stat_model.dart';

final aboutRepositoryProvider = Provider<AboutRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AboutRepository(apiClient);
});

class AboutRepository {
  AboutRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AboutStatModel>> getAboutStats() async {
    final response = await _apiClient.get(ApiEndpoints.aboutStats);
    final items = _unwrapList(response, 'stats');
    if (items.isEmpty) return AboutStatModel.getMockStats();

    return items
        .map(
          (item) => AboutStatModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>> getCompanyInfo() async {
    final response = await _apiClient.get(ApiEndpoints.companyInfo);
    if (response is Map<String, dynamic>) {
      return response['data'] ?? response;
    }

    return {
      'mission': 'Empowering Health, Preserving Heritage',
      'vision': 'Connecting ancient wisdom with modern wellness',
    };
  }

  List<Map<String, dynamic>> _unwrapList(dynamic response, String key) {
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }

    if (response is Map<String, dynamic>) {
      final data = response[key] ?? response['data'] ?? [];
      return List<Map<String, dynamic>>.from(data as List);
    }

    return <Map<String, dynamic>>[];
  }
}
