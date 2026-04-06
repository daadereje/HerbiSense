class SkinConcernModel {
  final int? id;
  final String title;
  final String description;
  final String? translatedTitle;
  final String? translatedDescription;
  final String? translationLanguage;
  final bool selected;
  final int severity;

  SkinConcernModel({
    this.id,
    required this.title,
    required this.description,
    this.translatedTitle,
    this.translatedDescription,
    this.translationLanguage,
    required this.selected,
    required this.severity,
  });

  factory SkinConcernModel.initial(String title, String description,
      {int? id}) {
    return SkinConcernModel(
      id: id,
      title: title,
      description: description,
      selected: false,
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
    bool? selected,
    int? severity,
  }) {
    return SkinConcernModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      translatedTitle: translatedTitle ?? this.translatedTitle,
      translatedDescription:
          translatedDescription ?? this.translatedDescription,
      translationLanguage: translationLanguage ?? this.translationLanguage,
      selected: selected ?? this.selected,
      severity: severity ?? this.severity,
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
      selected: json['selected'] == true,
      severity: level is num
          ? level.toInt()
          : (level is String ? int.tryParse(level) ?? 0 : 0),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'translated_name': translatedTitle,
      'translated_description': translatedDescription,
      'language': translationLanguage,
      'selected': selected,
      'severity': severity,
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
