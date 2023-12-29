import 'package:dio/dio.dart';

import '../../shared/config.dart';
import 'back4app_interceptor.dart';

class Back4AppCustomDio {
  final _dio = Dio();

  Dio get api => _dio;

  Back4AppCustomDio() {
    _dio.options.baseUrl = Config.urlBaseBack4App;
    _dio.interceptors.add(Back4AppInterceptor());
  }
}
