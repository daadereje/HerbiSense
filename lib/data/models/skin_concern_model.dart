class SkinConcernModel {
  final String title;
  final String description;
  final bool selected;
  final int severity;

  SkinConcernModel({
    required this.title,
    required this.description,
    required this.selected,
    required this.severity,
  });

  factory SkinConcernModel.initial(String title, String description) {
    return SkinConcernModel(
      title: title,
      description: description,
      selected: false,
      severity: 0,
    );
  }

  SkinConcernModel copyWith({
    String? title,
    String? description,
    bool? selected,
    int? severity,
  }) {
    return SkinConcernModel(
      title: title ?? this.title,
      description: description ?? this.description,
      selected: selected ?? this.selected,
      severity: severity ?? this.severity,
    );
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
