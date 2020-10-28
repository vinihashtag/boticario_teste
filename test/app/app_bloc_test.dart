import 'package:boticario/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(AppModule());
  // AppBloc bloc;

  // setUp(() {
  //     bloc = AppModule.to.get<AppBloc>();
  // });

  // group('AppBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<AppBloc>());
  //   });
  // });
}
