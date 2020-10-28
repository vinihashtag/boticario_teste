import 'package:bot_toast/bot_toast.dart';
import 'package:boticario/app/modules/home/repositories/post_repository.dart';
import 'package:boticario/app/shared/blocs/auth_bloc.dart';
import 'package:boticario/app/shared/models/post_model.dart';
import 'package:boticario/app/shared/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class PostsBloc extends Disposable {
  final PostRepository _repository;
  final AuthBloc _authBloc;

  PostsBloc(this._repository, this._authBloc) {
    getPosts();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // * Controla a lista de posts
  final _novidadesStream = BehaviorSubject<List<PostModel>>();
  Function(List<PostModel>) get setListPosts =>
      _novidadesStream.isClosed ? (v) => v : _novidadesStream.add;
  Stream<List<PostModel>> get getListPosts => _novidadesStream.stream;

  // * Controla status validação post
  final _statusStream = BehaviorSubject<StatusScreen>();
  Function(StatusScreen) get setStatus =>
      _statusStream.isClosed ? (v) => v : _statusStream.add;
  Stream<StatusScreen> get getStatus => _statusStream.stream;

  final List<PostModel> listaFake = [
    PostModel(
        id: 997,
        dataPost: DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        nomeUsuario: 'Ana',
        post: 'Gosto muito da nova linha da Boticário',
        userId: 997),
    PostModel(
        id: 998,
        dataPost: DateTime.now().subtract(Duration(days: 4)).toIso8601String(),
        nomeUsuario: 'Augusto',
        post: 'Muito massa este blog',
        userId: 998),
    PostModel(
        id: 999,
        dataPost: DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        nomeUsuario: 'Larissa',
        post: 'Gosto muito dos produtos da nova linha',
        userId: 999),
  ];

  // * Carrega os posts
  Future<void> getPosts() async {
    try {
      final lista = await _repository.queryAllRows();
      lista.addAll(listaFake);
      lista.sort((a, b) =>
          DateTime.parse(a.dataPost).compareTo(DateTime.parse(b.dataPost)));
      setListPosts(lista);
    } catch (e) {
      print(e);
      _novidadesStream.addError('Erro ao buscar os posts');
    }
  }

  // * atualizar post
  Future<void> updatePost(PostModel post) async {
    if (post?.id == null) {
      post.dataPost = DateTime.now().toIso8601String();
      post.nomeUsuario = _authBloc.user.nome;
      post.userId = _authBloc.user.id;
      await _repository.insert(post);
    } else {
      await _repository.update(post);
    }
    await getPosts();
    Get.back();
    BotToast.showText(
        text: post?.id == null
            ? 'Post criado com sucesso!'
            : 'Post atualizado com sucesso!',
        contentColor: Colors.green,
        align: Alignment.center);
  }

  //* deletar post
  Future<void> deletePost(PostModel postModel) async {
    await _repository.delete(postModel.id);
    await getPosts();
    Get.back();
    BotToast.showText(
        text: 'Post deletado com sucesso!',
        contentColor: Colors.green,
        align: Alignment.center);
  }

  @override
  void dispose() {
    _novidadesStream?.close();
    _statusStream?.close();
  }
}
