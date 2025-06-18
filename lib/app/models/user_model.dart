class UserModel {
  int id;
  int roleID;
  String avatar;
  String name;
  String email;
  String phone;
  String address;
  DateTime joinDate;

  UserModel({
    required this.id,
    required this.roleID,
    required this.avatar,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.joinDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      roleID: json['role_id'],
      avatar: json['avatar'] ?? '',
      name: json['name'],
      email: json['email'],
      phone: json['contact_number'] ?? '',
      address: json['address'] ?? '',
      joinDate: DateTime(2024, 1, 1), // Dummy date set to January 1, 2024
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleID,
      'avatar': avatar,
      'name': name,
      'email': email,
      'contact_number': phone,
      'address': address,
      'created_at': joinDate.toIso8601String(),
    };
  }
}
