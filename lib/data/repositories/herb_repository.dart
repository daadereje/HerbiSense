import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/network/api_client.dart';
import '../../common/network/api_endpoints.dart';
import '../models/herb_model.dart';

final herbRepositoryProvider = Provider<HerbRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return HerbRepository(apiClient);
});

class HerbRepository {
  HerbRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<HerbModel>> getAllHerbs() async {
    final response = await _apiClient.get(ApiEndpoints.herbsPublished);
    final items = _unwrapList(response, 'data');
    final herbs = items.map(HerbModel.fromJson).toList();

    // Hydrate each herb with its first upload image if available
    final enriched = await Future.wait(
      herbs.map((herb) async {
        final imageUrl = await _fetchFirstImageUrl(herb.id);
        return herb.copyWith(imageUrl: imageUrl);
      }),
    );

    return enriched;
  }

  Future<HerbModel?> getHerbById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.herbById(id));
    if (response == null) return null;

    final map = response is Map<String, dynamic>
        ? response
        : <String, dynamic>{};
    final data = map['data'] ?? map;

    return HerbModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<List<HerbModel>> searchHerbs({
    required String query,
    String? conditionId,
    int page = 1,
    int limit = 10,
    String sort = 'created_at',
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.herbSearch,
      queryParams: {
        'search': query,
        'page': page,
        'limit': limit,
        'sort': sort,
        if (conditionId != null && conditionId.isNotEmpty)
          'conditionId': conditionId,
      },
    );

    final items = _unwrapList(response, 'data');
    return items.map(HerbModel.fromJson).toList();
  }

  Future<List<HerbModel>> getHerbsByCondition(String condition) async {
    final queryParams = condition == 'All Conditions'
        ? null
        : <String, dynamic>{'condition': condition};

    final response = await _apiClient.get(
      ApiEndpoints.herbs,
      queryParams: queryParams,
    );

    final items = _unwrapList(response, 'herbs');
    return items.map(HerbModel.fromJson).toList();
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

  Future<String?> _fetchFirstImageUrl(String herbId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.uploadById(herbId.toString()));

      final data = response is Map<String, dynamic>
          ? response['data'] ?? response['uploads'] ?? response['images']
          : response;

      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) {
          return (first['url'] ??
                  first['path'] ??
                  first['image'] ??
                  first['location'])
              ?.toString();
        }
        return first.toString();
      }
    } catch (_) {
      // Fail silently; UI will show placeholder image
    }
    return null;
  }
}
