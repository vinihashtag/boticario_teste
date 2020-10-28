import 'package:boticario/app/app_module.dart';
import 'package:boticario/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(HomeModule());
  // PostsBloc bloc;

  // setUp(() {
  //     bloc = HomeModule.to.get<PostsBloc>();
  // });

  // group('PostsBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<PostsBloc>());
  //   });
  // });
}
