class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? profileImage;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static UserModel getMockUser() {
    return UserModel(
      id: '1',
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      isVerified: true,
      createdAt: DateTime.now(),
    );
  }
}
