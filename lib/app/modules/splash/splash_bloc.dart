import 'dart:convert';

import 'package:boticario/app/shared/blocs/auth_bloc.dart';
import 'package:boticario/app/shared/models/usuario_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBloc extends Disposable {
  SplashBloc() {
    proximaPagina();
  }

  Future<void> proximaPagina() async {
    Future.delayed(Duration(seconds: 2), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final AuthBloc _authBloc = Modular.get();
      _authBloc.user = sharedPreferences.get('user') == null
          ? UserModel()
          : UserModel.fromMap(json.decode(sharedPreferences.get('user')));
      if (_authBloc.user?.id == null) {
        Get.offAllNamed('/auth');
      } else {
        Get.offAllNamed('/home');
      }
    });
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {}
}
