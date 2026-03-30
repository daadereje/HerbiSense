import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/network/api_client.dart';
import '../../common/network/api_endpoints.dart';
import '../models/favorite_model.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return FavoritesRepository(apiClient);
});

class FavoritesRepository {
  FavoritesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FavoriteModel>> getFavorites() async {
    final response = await _apiClient.get(ApiEndpoints.favorites);
    final items = _unwrapList(response);
    return items.map(FavoriteModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _unwrapList(dynamic response) {
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }

    if (response is Map<String, dynamic>) {
      // common server shapes:
      // { "data": [ ... ] }
      // { "data": { "favorites": [ ... ], ... } }
      // { "favorites": [ ... ] }
      final possible = [
        response['data'],
        response['favorites'],
        response['items'],
        response['results'],
      ];

      for (final candidate in possible) {
        if (candidate is List) {
          return List<Map<String, dynamic>>.from(candidate);
        }
        if (candidate is Map<String, dynamic>) {
          final nestedList = candidate['favorites'] ??
              candidate['data'] ??
              candidate['items'] ??
              candidate['results'];
          if (nestedList is List) {
            return List<Map<String, dynamic>>.from(nestedList);
          }
        }
      }
    }

    return <Map<String, dynamic>>[];
  }
}
