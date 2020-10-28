class UserModel {
  num id;
  String nome;
  String email;
  String password;

  UserModel({
    this.id,
    this.nome,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nome: $nome, email: $email, password: $password)';
  }
}
