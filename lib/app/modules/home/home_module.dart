import 'package:flutter_modular/flutter_modular.dart';

import 'home_bloc.dart';
import 'home_page.dart';
import 'pages/novidades/novidades_bloc.dart';
import 'pages/posts/posts_bloc.dart';
import 'repositories/home_repository.dart';
import 'repositories/post_repository.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeBloc()),
        Bind((i) => PostsBloc(i(), i())),
        Bind((i) => NovidadesBloc(i())),
        Bind((i) => HomeRepository(i())),
        Bind((i) => PostRepository()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
