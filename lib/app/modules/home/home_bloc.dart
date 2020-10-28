import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeBloc extends Disposable {
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController?.dispose();
  }
}
