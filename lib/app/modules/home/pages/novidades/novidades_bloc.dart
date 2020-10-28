import 'package:boticario/app/modules/home/repositories/home_repository.dart';
import 'package:boticario/app/shared/models/news_model.dart';
import 'package:boticario/app/shared/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class NovidadesBloc extends Disposable {
  final HomeRepository _repository;

  NovidadesBloc(this._repository) {
    getNovidades();
  }

  final _novidadesStream = BehaviorSubject<List<News>>();
  Function(List<News>) get setListaNews =>
      _novidadesStream.isClosed ? (v) => v : _novidadesStream.add;
  Stream<List<News>> get getListaNews => _novidadesStream.stream;

  Future<void> getNovidades() async {
    try {
      final NewsModel lista = await _repository.getNovidades();
      lista.news.sort((a, b) => DateTime.parse(b.message.createdAt)
          .compareTo(DateTime.parse(a.message.createdAt)));
      setListaNews(lista.news);
    } catch (e) {
      if (e is DioError &&
          (e.type == DioErrorType.DEFAULT ||
              e.type == DioErrorType.CONNECT_TIMEOUT)) {
        SnackBarCustom.snackBarTop(
            mensagem: 'Verifique sua conexão de internet!',
            icon: Icon(Icons.error_outline, color: Colors.red));
      }
      print(e);
      _novidadesStream.addError('Erro ao buscar as novidades');
    }
  }

  @override
  void dispose() {
    _novidadesStream?.close();
  }
}
