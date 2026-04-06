import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_endpoints.dart';
import '../models/skin_concern_model.dart';

final recommendationRepositoryProvider =
    Provider<RecommendationRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return RecommendationRepository(apiClient);
});

class RecommendationRepository {
  RecommendationRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SkinConcernModel>> getSkinConcerns({String? language}) async {
    final response = await _apiClient.get(
      ApiEndpoints.skinConcerns,
      queryParams: _langParam(language),
    );
    final items = _unwrapList(response, 'data', fallbackKey: 'concerns');
    if (items.isEmpty) return SkinConcernModel.getMockConcerns();
    final base = items.map(SkinConcernModel.fromJson).toList();
    return _attachTranslations(base, language);
  }

  Future<List<SkinConcernModel>> searchConditions(String query,
      {String? language}) async {
    final response = await _apiClient.get(
      ApiEndpoints.conditionSearch,
      queryParams: {
        'search': query,
        ..._langParam(language),
      },
    );
    final items = _unwrapList(response, 'data', fallbackKey: 'conditions');
    final base = items.map(SkinConcernModel.fromJson).toList();
    return _attachTranslations(base, language);
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

  Map<String, dynamic> _langParam(String? code) {
    if (code == null || code.isEmpty) return {};
    final normalized = switch (code.toLowerCase()) {
      'amh' => 'AM',
      'or' => 'OM',
      'eng' => 'EN',
      _ => code.toUpperCase(),
    };
    return {'language': normalized};
  }

  Future<List<SkinConcernModel>> _attachTranslations(
    List<SkinConcernModel> base,
    String? language,
  ) async {
    if (language == null ||
        language.toLowerCase() == 'eng' ||
        language.toLowerCase() == 'en') {
      return base;
    }

    return Future.wait(base.map((c) async {
      final translated = await _fetchTranslation(c, language);
      if (translated == null) return c;
      return c.copyWith(
        translatedTitle: translated.translatedTitle,
        translatedDescription: translated.translatedDescription,
        translationLanguage: translated.translationLanguage,
      );
    }));
  }

  Future<SkinConcernModel?> _fetchTranslation(
    SkinConcernModel concern,
    String language,
  ) async {
    if (concern.id == null) return null;
    try {
      final resp = await _apiClient.get(
        ApiEndpoints.conditionTranslation(concern.id.toString()),
        queryParams: _langParam(language),
      );
      final data = _extractTranslation(resp, language);
      if (data == null) return null;
      return SkinConcernModel.fromJson({
        ...data,
        'condition_id': concern.id,
      });
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _extractTranslation(dynamic resp, String language) {
    if (resp is Map<String, dynamic>) {
      final data = resp['data'] ?? resp['translation'] ?? resp;
      if (data is Map<String, dynamic>) return data;
      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        final target = _langParam(language)['language']!.toString().toLowerCase();
        final match = data.firstWhere(
          (e) =>
              e is Map &&
              (e['language'] ?? e['lang'])
                  ?.toString()
                  .toLowerCase()
                  .startsWith(target) ==
                  true,
          orElse: () => null,
        );
        if (match is Map<String, dynamic>) return Map<String, dynamic>.from(match);
        return Map<String, dynamic>.from(data.first as Map);
      }
    }
    return null;
  }
}
