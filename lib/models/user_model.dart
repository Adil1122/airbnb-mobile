class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final bool isIdentityVerified;
  final bool isPhoneVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.isIdentityVerified = false,
    this.isPhoneVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      isIdentityVerified: json['isIdentityVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'isIdentityVerified': isIdentityVerified,
      'isPhoneVerified': isPhoneVerified,
    };
  }
}
