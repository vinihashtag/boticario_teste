import 'package:boticario/app/modules/home/pages/posts/posts_bloc.dart';
import 'package:boticario/app/shared/blocs/auth_bloc.dart';
import 'package:boticario/app/shared/models/post_model.dart';
import 'package:boticario/app/shared/utils/enums.dart';
import 'package:boticario/app/shared/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostsPage extends StatefulWidget {
  final String title;
  const PostsPage({Key key, this.title = "Posts"}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends ModularState<PostsPage, PostsBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 40),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        tooltip: 'Adicionar Post',
        onPressed: () => Get.dialog(addOrUpdatePost(PostModel())),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<PostModel>>(
          stream: controller.getListPosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Get.theme.accentColor, size: 80),
                    const SizedBox(height: 8),
                    Text(
                      'Erro ao buscar posts',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              );
            }
            if (snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Get.theme.accentColor, size: 80),
                    const SizedBox(height: 8),
                    Text(
                      'Não possuem posts no momento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              );
            }
            return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  final post = snapshot.data[index];
                  return ZoomInRight(
                    preferences: AnimationPreferences(
                        duration: Duration(milliseconds: 300)),
                    child: Card(
                      color: Color(0xFFe9eb01),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: post.userId !=
                                        Modular.get<AuthBloc>().user.id
                                    ? EdgeInsets.all(12)
                                    : EdgeInsets.only(left: 12),
                                child: Text(
                                  "${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(post.dataPost))} - ${post.nomeUsuario.split(' ').first.toUpperCase()}",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: post.userId ==
                                  Modular.get<AuthBloc>().user.id,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () =>
                                          Get.dialog(addOrUpdatePost(post))),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => Get.dialog(CustomDialog(
                                            descricao:
                                                'Deseja realmente remover este post?',
                                            onPressed: () =>
                                                controller.deletePost(post),
                                          ))),
                                ],
                              ),
                            )
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                          child: Card(
                            elevation: 0,
                            color: Colors.white70,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                post.post,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Widget addOrUpdatePost(PostModel postModel) {
    return AlertDialog(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 5, right: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 2)),
            child: Text(postModel?.id == null ? 'Novo Post' : 'Editar post',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                    fontSize: 14)),
          ),
          IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              onPressed: Get.back)
        ],
      ),
      actions: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ProgressButton(
                defaultWidget: Text(
                    postModel?.id == null ? 'Salvar' : 'Atualizar',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                progressWidget: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).accentColor,
                type: ProgressButtonType.Raised,
                onPressed: () => controller.updatePost(postModel)),
          ),
        )),
      ],
      content: StreamBuilder<StatusScreen>(
          stream: controller.getStatus,
          initialData: StatusScreen.initial,
          builder: (context, snapshot) {
            return Form(
              key: controller.formKey,
              autovalidateMode: snapshot.data == StatusScreen.error
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: TextFormField(
                  autocorrect: false,
                  maxLength: 280,
                  maxLines: 10,
                  initialValue: postModel?.post,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    hintText: 'Escreva aqui seu post',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  readOnly: snapshot.data == StatusScreen.loading,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'Informe o post';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (v) => postModel.post = v.trim(),
                ),
              ),
            );
          }),
    );
  }
}
