import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:boticario/app/modules/authentication/repositories/authentication_repository.dart';
import 'package:boticario/app/shared/blocs/auth_bloc.dart';
import 'package:boticario/app/shared/models/usuario_model.dart';
import 'package:boticario/app/shared/utils/enums.dart';
import 'package:boticario/app/shared/utils/snackbar.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterBloc extends Disposable {
  final AuthBloc _authBloc;
  final AuthenticationRepository _repository;
  RegisterBloc(this._authBloc, this._repository);

  UserModel user = UserModel();

  String confirmaSenha = '';

  // * Global Keys
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // * Stream que controla o status da tela
  final _statusStream = BehaviorSubject<StatusScreen>();
  Function(StatusScreen) get setStatus =>
      _statusStream.isClosed ? (v) => v : _statusStream.add;
  Stream<StatusScreen> get getStatus => _statusStream.stream;

  // * Stream que controla a exibição da senha
  final _senhaVisivelStram = BehaviorSubject<bool>();
  Function(bool) get setSenhaVisivel => _senhaVisivelStram.sink.add;
  Stream<bool> get getSenhaVisivel => _senhaVisivelStram.stream;

  // * Efetua o login por email e senha
  Future<void> signup() async {
    if (!formKey.currentState.validate()) {
      return setStatus(StatusScreen.error);
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setStatus(StatusScreen.loading);
    try {
      var existente = await _repository.findByEmail(user.email);
      if (existente != null) {
        setStatus(StatusScreen.error);
        return SnackBarCustom.snackBarTop(
            mensagem: 'Email já está sendo usado, crie outro!',
            icon: Icon(Icons.error_outline, color: Colors.red));
      }

      // * Gerando hash
      user.password = Crypt.sha256(user.password).toString();
      user.id = await _repository.insert(user);
      if (user.id == null) {
        setStatus(StatusScreen.error);
        return SnackBarCustom.snackBarTop(
            mensagem: 'Erro ao criar usuário!',
            icon: Icon(Icons.error_outline, color: Colors.red));
      }
      await Future.delayed(Duration(milliseconds: 500));
      _authBloc.user = user;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('user', json.encode(_authBloc.user.toMap()));
      _authBloc.setLogado(true);
      Get.offAllNamed('/home');
      BotToast.showText(text: 'Seja bem-vindo!', contentColor: Colors.green);
      // SnackBarCustom.snackSucessoTop(mensagem: 'Seja bem-vindo!');
    } on Exception catch (e) {
      print(e);
      setStatus(StatusScreen.error);
      SnackBarCustom.snackBarTop(
          mensagem: 'Erro ao fazer login!',
          icon: Icon(Icons.error_outline, color: Colors.red),
          backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    _statusStream?.close();
    _senhaVisivelStram?.close();
  }
}
