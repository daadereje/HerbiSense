import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/network/api_client.dart';
import '../../common/network/api_endpoints.dart';
import '../models/herb_model.dart';

final savedHerbsRepositoryProvider = Provider<SavedHerbsRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SavedHerbsRepository(apiClient);
});

class SavedHerbsRepository {
  SavedHerbsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<HerbModel>> getSavedHerbs() async {
    final response = await _apiClient.get(ApiEndpoints.savedHerbs);
    final items = _unwrapList(response);
    return items.map(HerbModel.fromJson).toList();
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
}
