import 'package:boticario/app/modules/home/pages/novidades/novidades_bloc.dart';
import 'package:boticario/app/shared/models/news_model.dart';
import 'package:boticario/app/shared/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NovidadesPage extends StatefulWidget {
  final String title;
  const NovidadesPage({Key key, this.title = "Novidades"}) : super(key: key);

  @override
  _NovidadesPageState createState() => _NovidadesPageState();
}

class _NovidadesPageState extends ModularState<NovidadesPage, NovidadesBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 40),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<News>>(
          stream: controller.getListaNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Get.theme.accentColor, size: 80),
                    const SizedBox(height: 8),
                    Text(
                      'Erro ao buscar novidades',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: controller.getNovidades,
                      icon: Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        'Tente novamente',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              );
            }
            if (snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Get.theme.accentColor, size: 80),
                    const SizedBox(height: 8),
                    Text(
                      'Não possuem novidades no momento',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              );
            }
            return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  final novidade = snapshot.data[index];
                  return ZoomInRight(
                    preferences: AnimationPreferences(
                        duration: Duration(milliseconds: 300)),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFe9eb01)),
                        child: Row(
                          children: [
                            Image.asset(
                              AssetsApp.boticarioLogo,
                              fit: BoxFit.contain,
                              height: 100,
                              width: 100,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '${novidade.user.name} - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(novidade.message.createdAt))}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      novidade.message.content,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          height: 1.4,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
