import 'package:boticario/app/shared/utils/assets.dart';
import 'package:boticario/app/shared/utils/enums.dart';
import 'package:boticario/app/shared/widgets/custom_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';

import 'authentication_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  final String title;
  const AuthenticationPage({Key key, this.title = "Authentication"})
      : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState
    extends ModularState<AuthenticationPage, AuthenticationBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<StatusScreen>(
          stream: controller.getStatus,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xFFed543b),
                    Color(0xFFed513f),
                    Color(0xFFea3f5b),
                  ])),
              child: Center(
                child: Form(
                  key: controller.formKey,
                  autovalidateMode: snapshot.data == StatusScreen.error
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        vertical: Get.height * .06, horizontal: Get.width * .1),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Hero(
                                tag: 'logo',
                                child: Image.asset(AssetsApp.boticario)),
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: snapshot.data == StatusScreen.loading,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 30),
                              CustomTextField(
                                onChanged: (v) => controller.email = v.trim(),
                                autocorrect: false,
                                filled: true,
                                autovalidate:
                                    snapshot.data == StatusScreen.error,
                                hintText: 'Email',
                                prefixIcon: Icon(FontAwesome.user_circle),
                                validator: (value) => value.isEmpty
                                    ? 'Informe seu email'
                                    : EmailValidator.validate(value)
                                        ? null
                                        : 'Informe um email válido',
                              ),
                              const SizedBox(height: 10),
                              StreamBuilder<bool>(
                                  stream: controller.getSenhaVisivel,
                                  initialData: true,
                                  builder: (context, snapshotSenha) {
                                    return CustomTextField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      onChanged: (v) =>
                                          controller.senha = v.trim(),
                                      obscureText: snapshotSenha.data,
                                      autocorrect: false,
                                      autovalidate:
                                          snapshot.data == StatusScreen.error,
                                      validator: (value) => value.isEmpty
                                          ? 'Informe sua senha'
                                          : value.length < 6
                                              ? 'Senha deve conter no minimo 6 caracteres'
                                              : null,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).unfocus(),
                                      filled: true,
                                      hintText: 'Senha',
                                      maxLines: 1,
                                      prefixIcon: Icon(FontAwesome.lock),
                                      suffixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: IconButton(
                                            icon: Icon(!snapshotSenha.data
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () =>
                                                controller.setSenhaVisivel(
                                                    !snapshotSenha.data)),
                                      ),
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: ProgressButton(
                                    defaultWidget: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    progressWidget:
                                        const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white)),
                                    height: 50,
                                    color: Get.theme.accentColor,
                                    onPressed: controller.login,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  height: 50,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.grey[400],
                                    borderSide: BorderSide(
                                        width: 5,
                                        color: Get.theme.accentColor
                                            .withOpacity(.6)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: Colors.blue[300],
                                    onPressed: () =>
                                        Get.offNamed('/auth/register'),
                                    child: Text(
                                      'CADASTRAR-SE',
                                      style: TextStyle(
                                          color: Get.theme.accentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
