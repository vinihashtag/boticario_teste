import 'package:boticario/app/shared/models/usuario_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends Disposable {
  // * Dados do usuário logado
  UserModel user;

  final _atualizaUsuarioStream = BehaviorSubject<bool>();
  Function(bool) get setAtualizaUsuario =>
      _atualizaUsuarioStream.isClosed ? (v) => v : _atualizaUsuarioStream.add;
  Stream<bool> get getAtualizaUsuario => _atualizaUsuarioStream.stream;

  // * Stream que controla se o usuário está logado ou não
  final _isLoggedStream = BehaviorSubject<bool>.seeded(false);
  Function(bool) get setLogado => _isLoggedStream.sink.add;
  Stream<bool> get getLogado => _isLoggedStream.stream;

  @override
  void dispose() {
    _atualizaUsuarioStream?.close();
    _isLoggedStream?.close();
  }
}
