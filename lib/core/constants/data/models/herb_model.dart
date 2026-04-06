class HerbModel {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String? preparation;
  final String? safetyWarning;
  final String? conditionId;
  final String? conditionName;
  final String? conditionDescription;
  final String? source;
  final String? translatedName;
  final String? translatedUses;
  final String? translatedPreparation;
  final String? translatedSafety;
  final String? translatedSource;
  final String? translationLanguage;
  final String category;
  final int views;
  final List<String> skinConditions;
  final String? imageUrl;
  final bool isTraditional;
  final bool isVerified;
  final String? status;

  HerbModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    this.preparation,
    this.safetyWarning,
    this.conditionId,
    this.conditionName,
    this.conditionDescription,
    this.source,
    this.translatedName,
    this.translatedUses,
    this.translatedPreparation,
    this.translatedSafety,
    this.translatedSource,
    this.translationLanguage,
    required this.category,
    required this.views,
    required this.skinConditions,
    this.imageUrl,
    required this.isTraditional,
    required this.isVerified,
    this.status,
  });

  factory HerbModel.fromJson(Map<String, dynamic> json) {
    final rawImage =
        json['imageUrl'] ?? json['image_url'] ?? json['image'] ?? '';
    final conditionMap =
        json['condition'] is Map ? Map<String, dynamic>.from(json['condition']) : null;

    final langCode =
        (json['language'] ?? json['lang'] ?? json['translation_language'])
            ?.toString();

    return HerbModel(
      id: (json['id'] ?? json['herb_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      scientificName: (json['scientific_name'] ??
              json['scientific'] ??
              json['scientificName'] ??
              '')
          .toString(),
      description: (json['description'] ?? '').toString(),
      preparation: (json['preparation'] ?? json['preparation_method'] ?? '')
              .toString()
              .isEmpty
          ? null
          : (json['preparation'] ?? json['preparation_method']).toString(),
      safetyWarning:
          (json['safety_warning'] ?? json['warning'] ?? '').toString().isEmpty
              ? null
              : (json['safety_warning'] ?? json['warning']).toString(),
      conditionId: (json['condition_id'] ?? conditionMap?['id'])?.toString(),
      conditionName: (json['condition_name'] ?? conditionMap?['name'])
          ?.toString(),
      conditionDescription: (json['condition_description'] ??
              conditionMap?['description'])
          ?.toString(),
      source: json['source']?.toString(),
      translatedName: json['translated_name']?.toString(),
      translatedUses: json['translated_uses']?.toString(),
      translatedPreparation: json['translated_preparation']?.toString(),
      translatedSafety: json['translated_safety']?.toString(),
      translatedSource: (json['translated_source'] ??
              (langCode != null ? json['source'] : null))
          ?.toString(),
      translationLanguage: langCode,
      category: (json['category'] ?? 'Traditional medicine').toString(),
      views: (json['views'] ?? json['view_count'] ?? 0) is num
          ? (json['views'] ?? json['view_count'] ?? 0 as num).toInt()
          : 0,
      skinConditions: List<String>.from(
        (json['skinConditions'] ??
                json['conditions'] ??
                json['skin_conditions'] ??
                [])
            .map((e) => e.toString()),
      ),
      imageUrl: rawImage.toString().isEmpty ? null : rawImage.toString(),
      isTraditional: json['isTraditional'] ?? json['traditional'] ?? true,
      isVerified: json['isVerified'] ?? json['verified'] ?? false,
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientific_name': scientificName,
      'description': description,
      'preparation': preparation,
      'safety_warning': safetyWarning,
      'condition_id': conditionId,
      'condition_name': conditionName,
      'condition_description': conditionDescription,
      'source': source,
      'translated_name': translatedName,
      'translated_uses': translatedUses,
      'translated_preparation': translatedPreparation,
      'translated_safety': translatedSafety,
      'translated_source': translatedSource,
      'translation_language': translationLanguage,
      'category': category,
      'views': views,
      'skinConditions': skinConditions,
      'imageUrl': imageUrl,
      'isTraditional': isTraditional,
      'isVerified': isVerified,
      'status': status,
    };
  }

  HerbModel copyWith({
    String? imageUrl,
    String? conditionName,
    String? conditionDescription,
    String? source,
    String? translatedName,
    String? translatedUses,
    String? translatedPreparation,
    String? translatedSafety,
    String? translatedSource,
    String? translationLanguage,
  }) {
    return HerbModel(
      id: id,
      name: name,
      scientificName: scientificName,
      description: description,
      preparation: preparation,
      safetyWarning: safetyWarning,
      conditionId: conditionId,
      conditionName: conditionName ?? this.conditionName,
      conditionDescription: conditionDescription ?? this.conditionDescription,
      source: source ?? this.source,
      translatedName: translatedName ?? this.translatedName,
      translatedUses: translatedUses ?? this.translatedUses,
      translatedPreparation: translatedPreparation ?? this.translatedPreparation,
      translatedSafety: translatedSafety ?? this.translatedSafety,
      translatedSource: translatedSource ?? this.translatedSource,
      translationLanguage: translationLanguage ?? this.translationLanguage,
      category: category,
      views: views,
      skinConditions: skinConditions,
      imageUrl: imageUrl ?? this.imageUrl,
      isTraditional: isTraditional,
      isVerified: isVerified,
      status: status,
    );
  }

  // Mock data for initial development
  static List<HerbModel> getMockHerbs() {
    return [
      HerbModel(
        id: '1',
        name: 'Neem',
        scientificName: 'Azadirachta indica',
        description:
            'Neem is a powerful medicinal tree native to the Indian subcontinent...',
        category: 'Traditional medicine',
        views: 164,
        skinConditions: ['Dry Skin', 'Skin infections'],
        isTraditional: true,
        isVerified: true,
      ),
      HerbModel(
        id: '2',
        name: 'Aloe Vera',
        scientificName: 'Aloe barbadensis miller',
        description:
            'Aloe vera is a succulent plant known for its soothing, moisturizing, and healing...',
        category: 'Traditional medicine',
        views: 417,
        skinConditions: ['Dry Skin', 'Sunburn', 'Minor Wounds'],
        isTraditional: true,
        isVerified: true,
      ),
      HerbModel(
        id: '3',
        name: 'Turmeric',
        scientificName: 'Curcuma longa',
        description:
            'Turmeric is a powerful antioxidant and anti-inflammatory herb used to...',
        category: 'Traditional medicine',
        views: 461,
        skinConditions: ['Inflammation', 'Acne', 'Dark Spots'],
        isTraditional: true,
        isVerified: true,
      ),
    ];
  }

  bool _matchesLanguage(String code) {
    if (translationLanguage == null || translationLanguage!.isEmpty) return false;
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
      _matchesLanguage(code) && (translatedName ?? '').isNotEmpty
          ? translatedName!
          : name;

  String usesFor(String code) =>
      _matchesLanguage(code) && (translatedUses ?? '').isNotEmpty
          ? translatedUses!
          : description;

  String preparationFor(String code) =>
      _matchesLanguage(code) && (translatedPreparation ?? '').isNotEmpty
          ? translatedPreparation!
          : (preparation ?? '');

  String safetyFor(String code) =>
      _matchesLanguage(code) && (translatedSafety ?? '').isNotEmpty
          ? translatedSafety!
          : (safetyWarning ?? '');

  String sourceFor(String code) =>
      _matchesLanguage(code) && (translatedSource ?? '').isNotEmpty
          ? translatedSource!
          : (source ?? '');
}
