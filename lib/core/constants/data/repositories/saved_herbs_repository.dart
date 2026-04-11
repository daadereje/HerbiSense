import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_endpoints.dart';
import '../models/herb_model.dart';

final savedHerbsRepositoryProvider = Provider<SavedHerbsRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SavedHerbsRepository(apiClient);
});

class SavedHerbsRepository {
  SavedHerbsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<HerbModel>> getSavedHerbs({String? language}) async {
    final response = await _apiClient.get(
      ApiEndpoints.savedHerbs,
      queryParams: _langParam(language),
    );
    final items = _unwrapList(response);
    final herbs = items.map(HerbModel.fromJson).toList();

    return Future.wait(herbs.map((herb) async {
      if (herb.imageUrl != null && herb.imageUrl!.isNotEmpty) return herb;
      final imageUrl = await _fetchFirstImageUrl(herb.id);
      return herb.copyWith(imageUrl: imageUrl);
    }));
  }

  Future<void> addSavedHerb(String herbId) async {
    final parsedId = int.tryParse(herbId);
    await _apiClient.post(
      ApiEndpoints.savedHerbs,
      body: {
        'herbId': parsedId ?? herbId,
      },
    );
  }

  Future<void> deleteSavedHerb(String herbId) async {
    final parsedId = int.tryParse(herbId);
    await _apiClient.delete(
      ApiEndpoints.savedHerbs,
      body: {
        'herbId': parsedId ?? herbId,
      },
    );
  }

  List<Map<String, dynamic>> _unwrapList(dynamic response) {
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }

    if (response is Map<String, dynamic>) {
      final possible = [
        response['data'],
        response['savedHerbs'],
        response['herbs'],
        response['items'],
        response['results'],
      ];

      for (final candidate in possible) {
        if (candidate is List) {
          return List<Map<String, dynamic>>.from(candidate);
        }
        if (candidate is Map<String, dynamic>) {
          final nested = candidate['savedHerbs'] ??
              candidate['herbs'] ??
              candidate['data'] ??
              candidate['items'] ??
              candidate['results'];
          if (nested is List) {
            return List<Map<String, dynamic>>.from(nested);
          }
        }
      }
    }

    return <Map<String, dynamic>>[];
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
      // ignore
    }
    return null;
  }
}
