import 'package:boticario/app/modules/home/pages/novidades/novidades_page.dart';
import 'package:boticario/app/modules/home/pages/posts/posts_page.dart';
import 'package:boticario/app/shared/utils/assets.dart';
import 'package:boticario/app/shared/widgets/dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Hero(
            tag: 'logo',
            child: Image.asset(
              AssetsApp.boticario,
              height: 40,
            )),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'Logoff',
              icon: Icon(Icons.exit_to_app),
              onPressed: () => Get.dialog(CustomDialog(
                    descricao: 'Deseja realmente fazer logoff?',
                    onPressed: () async {
                      Get.offAllNamed('/auth');
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.remove('user');
                    },
                  )))
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        children: [
          PostsPage(),
          NovidadesPage(),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: controller.pageController,
        builder: (BuildContext context, Widget child) {
          return CurvedNavigationBar(
              index: (controller.pageController?.page?.toInt()) ?? 0,
              items: <Widget>[
                Icon(Icons.home, size: 25, color: Colors.white),
                Icon(Icons.new_releases, size: 25, color: Colors.white),
              ],
              color: Theme.of(context).primaryColor,
              buttonBackgroundColor: Get.theme.primaryColor,
              backgroundColor: Get.theme.accentColor,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              onTap: (v) => controller.pageController.animateToPage(v,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut));
        },
      ),
    );
  }
}
