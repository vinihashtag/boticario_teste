import 'package:boticario/app/modules/splash/splash_module.dart';
import 'package:boticario/app/shared/blocs/auth_bloc.dart';
import 'package:dio/dio.dart';

import 'app_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:boticario/app/app_widget.dart';
import 'package:boticario/app/modules/home/home_module.dart';

import 'modules/authentication/authentication_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppBloc()),
        Bind((i) => AuthBloc()),
        Bind((i) => Dio()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: SplashModule()),
        ModularRouter('/auth', module: AuthenticationModule()),
        ModularRouter('/home', module: HomeModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
