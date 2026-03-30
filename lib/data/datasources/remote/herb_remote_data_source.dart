import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/network/api_client.dart';
import '../../../common/network/api_endpoints.dart';
import '../../models/herb_model.dart';

final herbRemoteDataSourceProvider = Provider<HerbRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return HerbRemoteDataSource(client);
});

class HerbRemoteDataSource {
  final ApiClient _client;

  HerbRemoteDataSource(this._client);

  Future<List<HerbModel>> fetchHerbs() async {
    final dynamic response = await _client.get(ApiEndpoints.herbs);
    final List<dynamic> list =
        response is List ? response : (response['data'] ?? []);
    return list
        .map((item) => HerbModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<HerbModel?> fetchHerbById(String id) async {
    final dynamic response = await _client.get(ApiEndpoints.herbById(id));
    final map = response is Map<String, dynamic> ? response : response['data'];
    if (map is Map<String, dynamic>) {
      return HerbModel.fromJson(map);
    }
    return null;
  }

  Future<List<HerbModel>> searchHerbs({
    required String query,
    String? conditionId,
    int page = 1,
    int limit = 10,
    String sort = 'created_at',
  }) async {
    final queryParams = <String, dynamic>{
      'search': query,
      'page': page,
      'limit': limit,
      'sort': sort,
      if (conditionId != null && conditionId.isNotEmpty)
        'conditionId': conditionId,
    };

    final dynamic response =
        await _client.get(ApiEndpoints.herbSearch, queryParams: queryParams);
    final List<dynamic> list =
        response is List ? response : (response['data'] ?? []);
    return list
        .map((item) => HerbModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<HerbModel>> fetchHerbsByCondition(String condition) async {
    final dynamic response =
        await _client.get(ApiEndpoints.herbs, queryParams: {'condition': condition});
    final List<dynamic> list =
        response is List ? response : (response['data'] ?? []);
    return list
        .map((item) => HerbModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
