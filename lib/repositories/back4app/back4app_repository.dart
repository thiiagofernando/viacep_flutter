import 'package:viacep_flutter/model/back4app_model.dart';
import 'package:viacep_flutter/model/via_cep_model.dart';
import 'package:viacep_flutter/repositories/back4app/back4app_dio.dart';

class Back4AppRepository {
  Future<RetornoBack4AppModel> obterTodos() async {
    var dio = Back4AppCustomDio();
    var url = 'cep_consulta';
    var result = await dio.api.get(url);
    return RetornoBack4AppModel.fromJson(result.data);
  }

  Future<void> inserirNaBase(RetornoViaCepModel dados) async {
    var dio = Back4AppCustomDio();
    var url = 'cep_consulta';
    await dio.api.post(url, data: dados.toJson());
  }
}
