import 'dart:convert';

class PostModel {
  int id;
  String nomeUsuario;
  String dataPost;
  String post;
  int userId;
  PostModel({
    this.id,
    this.nomeUsuario = '',
    this.dataPost = '',
    this.post = '',
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_usuario': nomeUsuario,
      'data_post': dataPost,
      'post': post,
      'user_id': userId,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PostModel(
      id: map['id'],
      nomeUsuario: map['nome_usuario'],
      dataPost: map['data_post'],
      post: map['post'],
      userId: map['user_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(id: $id, nomeUsuario: $nomeUsuario, dataPost: $dataPost, post: $post, userId: $userId)';
  }
}
