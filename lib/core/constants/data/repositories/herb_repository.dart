import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_endpoints.dart';
import '../models/herb_model.dart';

final herbRepositoryProvider = Provider<HerbRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return HerbRepository(apiClient);
});

class HerbRepository {
  HerbRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<HerbModel>> getAllHerbs({String? language}) async {
    final response = await _apiClient.get(
      ApiEndpoints.herbsPublished,
      queryParams: _langParam(language),
    );
    final items = _unwrapList(response, 'data');
    final herbs = items.map(HerbModel.fromJson).toList();

    final enriched = await _attachImagesAndTranslations(herbs, language);

    return enriched;
  }

  Future<HerbModel?> getHerbById(String id, {String? language}) async {
    final response = await _apiClient.get(
      ApiEndpoints.herbById(id),
      queryParams: _langParam(language),
    );
    if (response == null) return null;

    final map = response is Map<String, dynamic>
        ? response
        : <String, dynamic>{};
    final data = map['data'] ?? map;

    final herb = HerbModel.fromJson(Map<String, dynamic>.from(data as Map));
    return _attachTranslation(herb, language);
  }

  Future<List<HerbModel>> searchHerbs({
    required String query,
    String? conditionId,
    int page = 1,
    int limit = 10,
    String sort = 'created_at',
    String? language,
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
        ..._langParam(language),
      },
    );

    final items = _unwrapList(response, 'data');
    final herbs = items.map(HerbModel.fromJson).toList();
    return _attachImagesAndTranslations(herbs, language);
  }

  Future<List<HerbModel>> getHerbsByCondition(String condition,
      {String? language}) async {
    final queryParams = condition == 'All Conditions'
        ? null
        : <String, dynamic>{
            'condition': condition,
            ..._langParam(language),
          };

    final response = await _apiClient.get(
      ApiEndpoints.herbs,
      queryParams: queryParams,
    );

    final items = _unwrapList(response, 'herbs');
    return items.map(HerbModel.fromJson).toList();
  }

  Map<String, dynamic> _langParam(String? code) {
    if (code == null || code.isEmpty) return {};
    // API expects EN/AM/OM
    final normalized = switch (code.toLowerCase()) {
      'eng' => 'EN',
      'amh' => 'AM',
      'or' => 'OM',
      _ => code.toUpperCase(),
    };
    return {'language': normalized};
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

  Future<List<HerbModel>> _attachImagesAndTranslations(
    List<HerbModel> herbs,
    String? language,
  ) async {
    return Future.wait(
      herbs.map((herb) async {
        final imageUrl = await _fetchFirstImageUrl(herb.id);
        final withImage = herb.copyWith(imageUrl: imageUrl);
        return _attachTranslation(withImage, language);
      }),
    );
  }

  Future<HerbModel> _attachTranslation(
    HerbModel herb,
    String? language,
  ) async {
    if (language == null ||
        language.toLowerCase() == 'eng' ||
        language.toLowerCase() == 'en') {
      return herb;
    }

    try {
      final resp = await _apiClient.get(
        ApiEndpoints.translationByHerb(herb.id),
        queryParams: _langParam(language),
      );
      final translatedMap = _extractTranslation(resp, language: language);
      if (translatedMap != null) {
        final translated = HerbModel.fromJson({
          ...translatedMap,
          'id': herb.id,
          'herb_id': herb.id,
        });
        return herb.copyWith(
          translatedName: translated.translatedName,
          translatedUses: translated.translatedUses,
          translatedPreparation: translated.translatedPreparation,
          translatedSafety: translated.translatedSafety,
          translatedSource: translated.translatedSource ?? translated.source,
          translationLanguage: translated.translationLanguage,
        );
      }
    } catch (_) {
      // ignore translation fetch errors
    }
    return herb;
  }

  Map<String, dynamic>? _extractTranslation(dynamic resp, {String? language}) {
    if (resp is Map<String, dynamic>) {
      final data = resp['data'] ?? resp['translation'] ?? resp;
      if (data is Map<String, dynamic>) return data;
      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        if (language != null && language.isNotEmpty) {
          final target = _langParam(language)['language']?.toString().toLowerCase();
          final match = data.firstWhere(
            (e) =>
                e is Map &&
                (e['language'] ?? e['lang'])
                        ?.toString()
                        .toLowerCase()
                        .startsWith(target ?? '') ==
                    true,
            orElse: () => null,
          );
          if (match is Map<String, dynamic>) {
            return Map<String, dynamic>.from(match);
          }
        }
        return Map<String, dynamic>.from(data.first as Map);
      }
    }
    return null;
  }
}
