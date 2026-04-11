import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_endpoints.dart';
import '../models/favorite_model.dart';
import '../models/herb_model.dart';

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

  Future<List<HerbModel>> getFavoriteHerbs({String? language}) async {
    final response = await _apiClient.get(
      ApiEndpoints.favorites,
      queryParams: _langParam(language),
    );
    final items = _unwrapList(response);
    final herbs = items.map(HerbModel.fromJson).toList();

    // Backfill image URLs when the favorites endpoint doesn't include them.
    return Future.wait(
      herbs.map((herb) async {
        if (herb.imageUrl != null && herb.imageUrl!.isNotEmpty) {
          return herb;
        }
        final imageUrl = await _fetchFirstImageUrl(herb.id);
        return herb.copyWith(imageUrl: imageUrl);
      }),
    );
  }

  Map<String, String> _langParam(String? code) {
    if (code == null || code.isEmpty) return {};
    final normalized = switch (code.toLowerCase()) {
      'amh' => 'AM',
      'or' => 'OM',
      'eng' => 'EN',
      _ => code.toUpperCase(),
    };
    return {
      'language': normalized,
      'lang': normalized,
    };
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
      // ignore and fall back to placeholder
    }
    return null;
  }
}
