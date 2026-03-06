class HerbModel {
  final String id;
  final String name;
  final String scientificName;
  final String description;
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
    required this.category,
    required this.views,
    required this.skinConditions,
    this.imageUrl,
    required this.isTraditional,
    required this.isVerified,
  });

  factory HerbModel.fromJson(Map<String, dynamic> json) {
    return HerbModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scientificName: json['scientific'] ?? json['scientificName'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Traditional medicine',
      views: json['views'] ?? 0,
      skinConditions: List<String>.from(json['skinConditions'] ?? []),
      imageUrl: json['imageUrl'],
      isTraditional: json['isTraditional'] ?? true,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'description': description,
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
        description: 'Neem is a powerful medicinal tree native to the Indian subcontinent...',
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
        description: 'Aloe vera is a succulent plant known for its soothing, moisturizing, and healing...',
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
        description: 'Turmeric is a powerful antioxidant and anti-inflammatory herb used to...',
        category: 'Traditional medicine',
        views: 461,
        skinConditions: ['Inflammation', 'Acne', 'Dark Spots'],
        isTraditional: true,
        isVerified: true,
      ),
    ];
  }
}
