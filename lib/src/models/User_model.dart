class UserModel {
  String? id;
  String userName;
  String? password;
  String email;
  String? status;
  String? rol;

  UserModel({
    required this.email,
    this.id,
    required this.userName,
    this.password,
    this.status,
    this.rol,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      userName: json['user_name'],
      email: json['email'],
      status: json['status'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson(UserModel user) {
    return {
      'user_name': user.userName,
      'password': user.password,
      'email': user.email,
      'status': user.status,
      'rol': user.rol,
    };
  }
}
