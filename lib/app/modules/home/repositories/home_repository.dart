import 'package:boticario/app/shared/models/news_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeRepository extends Disposable {
  final Dio _dio;

  HomeRepository(this._dio);

  Future getNovidades() async {
    try {
      final response = await _dio
          .get('https://gb-mobile-app-teste.s3.amazonaws.com/data.json');
      return NewsModel.fromJson(response.data);
    } on DioError catch (e) {
      throw (e);
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
