class UserModel {
  final String email;
  final String name;
  final String role;
  final String phone;

  UserModel({
    required this.email,
    required this.name,
    required this.role,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['Email']?.toString() ?? '',
      name: json['Name']?.toString() ?? '',
      role: json['Role']?.toString() ?? '',
      phone: json['Phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Name': name,
      'Role': role,
      'Phone': phone,
    };
  }
}
