import 'package:boticario/app/shared/utils/assets.dart';
import 'package:boticario/app/shared/utils/enums.dart';
import 'package:boticario/app/shared/widgets/custom_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';

import 'register_bloc.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key key, this.title = "Criar Conta"}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ModularState<RegisterPage, RegisterBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.offNamed('/auth')),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: StreamBuilder<StatusScreen>(
          stream: controller.getStatus,
          builder: (context, snapshot) {
            return Form(
              key: controller.formKey,
              autovalidateMode: snapshot.data == StatusScreen.error
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * .05, vertical: Get.height * .04),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Hero(
                            tag: 'logo',
                            child: Image.asset(
                              AssetsApp.boticario,
                              height: Get.height * .2,
                            )),
                      ),
                    ),
                    //* Nome
                    CustomTextField(
                      onChanged: (v) => controller.user.nome = v.trim(),
                      autocorrect: false,
                      validator: (value) =>
                          value.trim().isEmpty ? 'Informe seu nome' : null,
                      filled: true,
                      labelText: 'Nome',
                      hintText: 'Seu nome',
                      prefixIcon: Icon(FontAwesome.user),
                    ),

                    // * Email
                    CustomTextField(
                      onChanged: (v) => controller.user.email = v.trim(),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value.trim().isEmpty
                          ? 'Informe seu email'
                          : EmailValidator.validate(value)
                              ? null
                              : 'Informe um email válido',
                      filled: true,
                      labelText: 'Email',
                      hintText: 'exemplo@gmail.com',
                      prefixIcon: Icon(Icons.email),
                    ),

                    // * Senha
                    StreamBuilder<bool>(
                        stream: controller.getSenhaVisivel,
                        initialData: true,
                        builder: (context, snapshotSenha) {
                          return CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (v) =>
                                controller.user.password = v.trim(),
                            obscureText: snapshotSenha.data,
                            autocorrect: false,
                            hintText: 'Sua senha de acesso',
                            validator: (value) => value.isEmpty
                                ? 'Informe sua senha'
                                : value.length < 6
                                    ? 'Senha deve conter no minimo 6 caracteres'
                                    : null,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            filled: true,
                            labelText: 'Senha',
                            maxLines: 1,
                            prefixIcon: Icon(FontAwesome.lock),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: IconButton(
                                  icon: Icon(!snapshotSenha.data
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => controller
                                      .setSenhaVisivel(!snapshotSenha.data)),
                            ),
                          );
                        }),

                    // * Confirma Senha
                    StreamBuilder<bool>(
                        stream: controller.getSenhaVisivel,
                        initialData: true,
                        builder: (context, snapshotSenha) {
                          return CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (v) =>
                                controller.confirmaSenha = v.trim(),
                            obscureText: snapshotSenha.data,
                            autocorrect: false,
                            hintText: 'Confirme sua senha',
                            validator: (value) => value.isEmpty
                                ? 'Informe sua senha'
                                : value.length < 6
                                    ? 'Senha deve conter no minimo 6 caracteres'
                                    : value == controller.user.password
                                        ? null
                                        : 'Senhas divergentes, verifique!',
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            filled: true,
                            labelText: 'Confirma Senha',
                            maxLines: 1,
                            prefixIcon: Icon(FontAwesome.lock),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: IconButton(
                                  icon: Icon(!snapshotSenha.data
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => controller
                                      .setSenhaVisivel(!snapshotSenha.data)),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ProgressButton(
                          defaultWidget: Text(
                            'CRIAR CONTA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          progressWidget: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white)),
                          height: 50,
                          color: Get.theme.primaryColor,
                          onPressed: controller.signup,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
