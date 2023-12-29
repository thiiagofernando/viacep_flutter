import 'package:dio/dio.dart';

import '../../shared/config.dart';

class ViaCepCustomDio {
  final _dio = Dio();

  Dio get api => _dio;

  ViaCepCustomDio() {
    _dio.options.baseUrl = Config.urlBaseViaCep;
  }
}
