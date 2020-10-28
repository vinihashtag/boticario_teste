import 'package:auto_size_text/auto_size_text.dart';
import 'package:boticario/app/shared/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import 'splash_bloc.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key key, this.title = "Splash"}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ModularState<SplashPage, SplashBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xFFed543b),
              Color(0xFFed513f),
              Color(0xFFea3f5b),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomInDown(
              child: Center(
                child: Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    radius: Get.height * .2,
                    backgroundImage: AssetImage(AssetsApp.logo),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * .05),
            ZoomInRight(
                preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 1200)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  child: AutoSizeText(
                    'Vinicius Souza de Oliveira',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 20,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(height: Get.height * .02),
            ZoomInLeft(
                preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 1500)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  child: AutoSizeText('vinnycin.souza@gmail.com',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 18,
                      style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                ))
          ],
        ),
      ),
    );
  }
}
