import 'package:boticario/app/app_module.dart';
import 'package:boticario/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(HomeModule());
  // NovidadesBloc bloc;

  // setUp(() {
  //     bloc = HomeModule.to.get<NovidadesBloc>();
  // });

  // group('NovidadesBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<NovidadesBloc>());
  //   });
  // });
}
