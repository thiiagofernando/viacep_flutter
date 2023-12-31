import 'package:flutter/material.dart';
import 'package:viacep_flutter/model/via_cep_model.dart';
import 'package:viacep_flutter/repositories/via_cep/via_cep_dio.dart';

import '../back4app/back4app_repository.dart';

class ViaCepRepository {
  Future<RetornoViaCepModel> consultarCep(String cepInformado, bool inserirNaBase) async {
    var dio = ViaCepCustomDio();
    var url = '$cepInformado/json/';
    var result = await dio.api.get(url);

    var retorno = RetornoViaCepModel.fromMap(result.data);
    if (inserirNaBase) {
      var backRepo = Back4AppRepository();
      await backRepo.inserirNaBase(retorno);
    }
    return retorno;
  }
}
