class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? role;
  final String? token;
  final String? profileImage;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.role,
    this.token,
    this.profileImage,
    required this.isVerified,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? role,
    String? token,
    String? profileImage,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final created = json['created_at'] ??
        json['createdAt'] ??
        DateTime.now().toIso8601String();
    final idValue = json['id'];
    final fullNameValue = json['full_name'] ?? json['fullName'] ?? '';

    return UserModel(
      id: idValue != null ? idValue.toString() : '',
      fullName: fullNameValue.toString(),
      email: (json['email'] ?? '').toString(),
      role: json['role']?.toString(),
      token: json['token']?.toString(),
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? json['verified'] ?? false,
      createdAt: DateTime.tryParse(created.toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'token': token,
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
