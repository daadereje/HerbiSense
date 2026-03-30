class FavoriteModel {
  final int id;
  final String name;
  final String description;
  final int? herbId;
  final String? linkedHerbName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavoriteModel({
    required this.id,
    required this.name,
    required this.description,
    this.herbId,
    this.linkedHerbName,
    this.createdAt,
    this.updatedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: (json['id'] ?? 0) is num ? (json['id'] as num).toInt() : 0,
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      herbId: json['herb_id'] is num ? (json['herb_id'] as num).toInt() : null,
      linkedHerbName: json['linked_herb_name']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  List<String> get tags {
    if (linkedHerbName != null && linkedHerbName!.isNotEmpty) {
      return [linkedHerbName!];
    }
    if (herbId != null) {
      return ['Herb #$herbId'];
    }
    return const [];
  }

  String? get extraNote {
    if (createdAt != null) {
      return 'Added on ${createdAt!.toLocal().toIso8601String().split('T').first}';
    }
    return null;
  }
}
