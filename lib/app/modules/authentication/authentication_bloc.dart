import 'dart:convert';

import 'package:boticario/app/shared/blocs/auth_bloc.dart';
import 'package:boticario/app/shared/utils/enums.dart';
import 'package:boticario/app/shared/utils/snackbar.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repositories/authentication_repository.dart';

class AuthenticationBloc extends Disposable {
  final AuthBloc _authBloc;
  final AuthenticationRepository _repository;
  AuthenticationBloc(this._authBloc, this._repository);

  // * Dados para autenticação por email e senha
  String email, senha;

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
  Future<void> login() async {
    if (!formKey.currentState.validate()) {
      return setStatus(StatusScreen.error);
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setStatus(StatusScreen.loading);
    try {
      _authBloc.user = await _repository.findByEmail(email);

      if (_authBloc.user != null) {
        // * Decode senha
        final hash = Crypt(_authBloc.user.password);
        if (hash.match(senha)) {
          _authBloc.setLogado(true);
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString(
              'user', json.encode(_authBloc.user.toMap()));
          return Get.offAllNamed('/home');
        }
      } else {
        setStatus(StatusScreen.error);
        SnackBarCustom.snackBarBottom(
            mensagem:
                'Login inválido, verifique o usuário e a senha, tente novamente!',
            icon: Icon(Icons.error_outline, color: Colors.red));
        return;
      }
    } on Exception catch (e) {
      print(e);
      setStatus(StatusScreen.error);
      SnackBarCustom.snackBarBottom(
          mensagem: 'Erro ao fazer login!',
          icon: Icon(Icons.error_outline, color: Colors.red));
    }
  }

  @override
  void dispose() {
    _statusStream.close();
    _senhaVisivelStram.close();
  }
}
