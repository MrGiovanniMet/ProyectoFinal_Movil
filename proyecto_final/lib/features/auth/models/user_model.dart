class UserModel {
  final int? localId;
  final String username;
  final String email;
  final String password;

  UserModel({
    this.localId,
    required this.username,
    required this.email,
    required this.password,
  });

  // regresa en un diccionario todas las claves para no acceder de 1 en 1
  Map<String, dynamic> toMap() {
    return {
      'localId': localId,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      localId: map['localId'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}