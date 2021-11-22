class UserModel {
  String id;
  String externalId;
  String userName;
  String? password;
  String email;
  String? status;
  String rol;

  UserModel({
    required this.email,
    required this.id,
    required this.externalId,
    required this.userName,
    this.password,
    this.status,
    required this.rol,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      externalId: json['external_id'],
      userName: json['user_name'],
      email: json['email'],
      status: json['status'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson(UserModel user) {
    return {
      'external_id': user.externalId,
      'user_name': user.userName,
      'password': user.password,
      'email': user.email,
      'status': user.status,
      'rol': user.rol,
    };
  }
}
