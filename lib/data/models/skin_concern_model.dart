class SkinConcernModel {
  final int? id;
  final String title;
  final String description;
  final bool selected;
  final int severity;

  SkinConcernModel({
    this.id,
    required this.title,
    required this.description,
    required this.selected,
    required this.severity,
  });

  factory SkinConcernModel.initial(String title, String description, {int? id}) {
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
    bool? selected,
    int? severity,
  }) {
    return SkinConcernModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      selected: selected ?? this.selected,
      severity: severity ?? this.severity,
    );
  }

  factory SkinConcernModel.fromJson(Map<String, dynamic> json) {
    final dynamic level = json['severity'] ?? json['level'];
    return SkinConcernModel(
      id: (json['id'] ?? json['condition_id']) is num
          ? (json['id'] ?? json['condition_id']).toInt()
          : null,
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      selected: json['selected'] == true,
      severity: level is num ? level.toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
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
}
