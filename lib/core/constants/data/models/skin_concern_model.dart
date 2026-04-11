class SkinConcernModel {
  final int? id;
  final String title;
  final String description;
  final String? translatedTitle;
  final String? translatedDescription;
  final String? translationLanguage;
  final int severity;
  final String? linkedHerbName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ConditionHerbModel> herbs;

  SkinConcernModel({
    this.id,
    required this.title,
    required this.description,
    this.translatedTitle,
    this.translatedDescription,
    this.translationLanguage,
    required this.severity,
    this.linkedHerbName,
    this.createdAt,
    this.updatedAt,
    this.herbs = const [],
  });

  factory SkinConcernModel.initial(String title, String description,
      {int? id}) {
    return SkinConcernModel(
      id: id,
      title: title,
      description: description,
      severity: 0,
    );
  }

  SkinConcernModel copyWith({
    int? id,
    String? title,
    String? description,
    String? translatedTitle,
    String? translatedDescription,
    String? translationLanguage,
    int? severity,
    String? linkedHerbName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ConditionHerbModel>? herbs,
  }) {
    return SkinConcernModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      translatedTitle: translatedTitle ?? this.translatedTitle,
      translatedDescription:
          translatedDescription ?? this.translatedDescription,
      translationLanguage: translationLanguage ?? this.translationLanguage,
      severity: severity ?? this.severity,
      linkedHerbName: linkedHerbName ?? this.linkedHerbName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      herbs: herbs ?? this.herbs,
    );
  }

  factory SkinConcernModel.fromJson(Map<String, dynamic> json) {
    final dynamic level = json['severity'] ?? json['level'];
    return SkinConcernModel(
      id: _parseInt(json['id'] ?? json['condition_id']),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      translatedTitle: json['translated_name']?.toString(),
      translatedDescription: json['translated_description']?.toString(),
      translationLanguage: json['language']?.toString(),
      severity: level is num
          ? level.toInt()
          : (level is String ? int.tryParse(level) ?? 0 : 0),
      linkedHerbName: json['linked_herb_name']?.toString(),
      createdAt: _parseDateTime(json['created_at']?.toString()),
      updatedAt: _parseDateTime(json['updated_at']?.toString()),
      herbs: _parseHerbs(json['herbs']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.tryParse(value);
    } catch (_) {
      return null;
    }
  }

  static List<ConditionHerbModel> _parseHerbs(dynamic rawHerbs) {
    if (rawHerbs is List) {
      return rawHerbs
          .whereType<Map<String, dynamic>>()
          .map(ConditionHerbModel.fromJson)
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'translated_name': translatedTitle,
      'translated_description': translatedDescription,
      'language': translationLanguage,
      'severity': severity,
      'linked_herb_name': linkedHerbName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'herbs': herbs.map((herb) => herb.toJson()).toList(),
    };
  }

  String get severityText {
    switch (severity) {
      case 1:
        return 'Mild';
      case 2:
        return 'Moderate';
      case 3:
        return 'Severe';
      default:
        return '';
    }
  }

  static List<SkinConcernModel> getMockConcerns() {
    return [
      SkinConcernModel.initial(
        'Dryness',
        'Flaky, rough, or tight skin lacking moisture',
      ),
      SkinConcernModel.initial(
        'Inflammation',
        'Redness, swelling, or irritation of the skin',
      ),
      SkinConcernModel.initial(
        'Acne',
        'Pimples, blackheads, whiteheads, or cysts',
      ),
      SkinConcernModel.initial(
        'Eczema',
        'Itchy, inflamed, or patchy skin conditions',
      ),
      SkinConcernModel.initial(
        'Sunburn',
        'Red, painful skin damage from sun exposure',
      ),
      SkinConcernModel.initial(
        'Dark Spots',
        'Hyperpigmentation or age spots on skin',
      ),
      SkinConcernModel.initial(
        'Fine Lines',
        'Early signs of aging or expression lines',
      ),
      SkinConcernModel.initial(
        'Minor Wounds',
        'Cuts, scrapes, or small injuries on skin',
      ),
    ];
  }

  bool _matchesLanguage(String code) {
    if (translationLanguage == null || translationLanguage!.isEmpty) {
      if (code.toLowerCase() == 'eng' || code.toLowerCase() == 'en') {
        return false;
      }
      return (translatedTitle?.isNotEmpty == true ||
          translatedDescription?.isNotEmpty == true);
    }
    final normalized = translationLanguage!.toLowerCase();
    final target = switch (code.toLowerCase()) {
      'amh' => 'am',
      'or' => 'om',
      'eng' => 'en',
      _ => code.toLowerCase(),
    };
    return normalized.startsWith(target);
  }

  String titleFor(String code) =>
      _matchesLanguage(code) && (translatedTitle ?? '').isNotEmpty
          ? translatedTitle!
          : title;

  String descriptionFor(String code) =>
      _matchesLanguage(code) && (translatedDescription ?? '').isNotEmpty
          ? translatedDescription!
          : description;
}

class ConditionHerbModel {
  final int? id;
  final String name;
  final String scientificName;
  final String description;
  final String? preparation;
  final String? safetyWarning;
  final String? source;
  final String? status;
  final double? averageRating;
  final int? ratingCount;
  final double? ratingValue;
  final String? imageUrl;
  final String? translatedName;
  final String? translatedDescription;
  final String? translatedPreparation;
  final String? translatedSafety;
  final String? translationLanguage;

  ConditionHerbModel({
    this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    this.preparation,
    this.safetyWarning,
    this.source,
    this.status,
    this.averageRating,
    this.ratingCount,
    this.ratingValue,
    this.imageUrl,
    this.translatedName,
    this.translatedDescription,
    this.translatedPreparation,
    this.translatedSafety,
    this.translationLanguage,
  });

  factory ConditionHerbModel.fromJson(Map<String, dynamic> json) {
    final avgRating = json['average_rating'] ?? json['avg_rating'];
    final translation = json['translation'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['translation'] as Map)
        : json['translation'] is Map
            ? Map<String, dynamic>.from(json['translation'] as Map)
            : null;

    return ConditionHerbModel(
      id: _parseInt(json['id']),
      name: (json['name'] ?? '').toString(),
      scientificName:
          (json['scientific_name'] ?? json['scientificName'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      preparation: (json['preparation'] ?? '').toString().isEmpty
          ? null
          : (json['preparation'] ?? '').toString(),
      safetyWarning:
          (json['safety_warning'] ?? json['warning'] ?? '').toString().isEmpty
              ? null
              : (json['safety_warning'] ?? json['warning']).toString(),
      source: translation?['source']?.toString() ?? json['source']?.toString(),
      status: json['status']?.toString(),
      averageRating: avgRating is num
          ? avgRating.toDouble()
          : (avgRating is String ? double.tryParse(avgRating) : null),
      ratingCount: _parseInt(json['rating_count']),
      ratingValue: _parseDouble(json['rating_value'] ?? json['rating']),
      imageUrl: (json['image'] ?? json['image_url'])?.toString(),
      translatedName: translation?['translated_name']?.toString() ??
          json['translated_name']?.toString(),
      translatedDescription: translation?['translated_uses']?.toString() ??
          translation?['translated_description']?.toString() ??
          json['translated_description']?.toString(),
      translatedPreparation:
          translation?['translated_preparation']?.toString() ??
              json['translated_preparation']?.toString(),
      translatedSafety: translation?['translated_safety']?.toString() ??
          json['translated_safety']?.toString(),
      translationLanguage: translation?['language']?.toString() ??
          translation?['lang']?.toString() ??
          (json['language'] ?? json['translation_language'])?.toString(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool _matchesLanguage(String code) {
    if (translationLanguage == null || translationLanguage!.isEmpty) {
      if (code.toLowerCase() == 'eng' || code.toLowerCase() == 'en') {
        return false;
      }
      return (translatedName?.isNotEmpty == true ||
          translatedDescription?.isNotEmpty == true ||
          translatedPreparation?.isNotEmpty == true ||
          translatedSafety?.isNotEmpty == true);
    }

    final normalized = translationLanguage!.toLowerCase();
    final target = switch (code.toLowerCase()) {
      'amh' => 'am',
      'or' => 'om',
      'eng' => 'en',
      _ => code.toLowerCase(),
    };
    return normalized.startsWith(target);
  }

  String nameFor(String code) =>
      (code.toLowerCase() != 'eng' &&
              (translatedName ?? '').isNotEmpty) ||
              (_matchesLanguage(code) && (translatedName ?? '').isNotEmpty)
          ? translatedName!
          : name;

  String descriptionFor(String code) =>
      (code.toLowerCase() != 'eng' &&
              (translatedDescription ?? '').isNotEmpty) ||
              (_matchesLanguage(code) &&
                  (translatedDescription ?? '').isNotEmpty)
          ? translatedDescription!
          : description;

  String preparationFor(String code) =>
      (code.toLowerCase() != 'eng' &&
              (translatedPreparation ?? '').isNotEmpty) ||
              (_matchesLanguage(code) &&
                  (translatedPreparation ?? '').isNotEmpty)
          ? translatedPreparation!
          : (preparation ?? '');

  String safetyFor(String code) =>
      (code.toLowerCase() != 'eng' &&
              (translatedSafety ?? '').isNotEmpty) ||
              (_matchesLanguage(code) && (translatedSafety ?? '').isNotEmpty)
          ? translatedSafety!
          : (safetyWarning ?? '');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'description': description,
      'preparation': preparation,
      'safety_warning': safetyWarning,
      'source': source,
      'status': status,
      'average_rating': averageRating,
      'rating_count': ratingCount,
      'rating_value': ratingValue,
      'image': imageUrl,
      'translated_name': translatedName,
      'translated_description': translatedDescription,
      'translated_preparation': translatedPreparation,
      'translated_safety': translatedSafety,
      'translation_language': translationLanguage,
    };
  }
}
