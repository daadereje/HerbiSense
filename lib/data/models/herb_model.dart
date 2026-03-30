class HerbModel {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String? preparation;
  final String? safetyWarning;
  final String? conditionId;
  final String? conditionName;
  final String category;
  final int views;
  final List<String> skinConditions;
  final String? imageUrl;
  final bool isTraditional;
  final bool isVerified;

  HerbModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    this.preparation,
    this.safetyWarning,
    this.conditionId,
    this.conditionName,
    required this.category,
    required this.views,
    required this.skinConditions,
    this.imageUrl,
    required this.isTraditional,
    required this.isVerified,
  });

  factory HerbModel.fromJson(Map<String, dynamic> json) {
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
      conditionId: json['condition_id']?.toString(),
      conditionName: json['condition_name']?.toString(),
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
      imageUrl: json['imageUrl']?.toString(),
      isTraditional: json['isTraditional'] ?? json['traditional'] ?? true,
      isVerified: json['isVerified'] ?? json['verified'] ?? false,
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
      'category': category,
      'views': views,
      'skinConditions': skinConditions,
      'imageUrl': imageUrl,
      'isTraditional': isTraditional,
      'isVerified': isVerified,
    };
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
}
