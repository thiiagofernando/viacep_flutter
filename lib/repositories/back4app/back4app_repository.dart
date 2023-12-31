import 'package:viacep_flutter/model/back4app_model.dart';
import 'package:viacep_flutter/model/via_cep_model.dart';
import 'package:viacep_flutter/repositories/back4app/back4app_dio.dart';

import '../../dto/atualizar_dados_dto.dart';

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

  Future<void> atualizar(AtualizarDadosDto dados, String id) async {
    var dio = Back4AppCustomDio();
    var url = 'cep_consulta/$id';
    await dio.api.put(url, data: dados.toJson());
  }

  Future<void> deletar(String id) async {
    var dio = Back4AppCustomDio();
    var url = 'cep_consulta/$id';
    await dio.api.delete(url);
  }
}
