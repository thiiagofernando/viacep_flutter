import 'package:viacep_flutter/model/via_cep_model.dart';
import 'package:viacep_flutter/repositories/via_cep/via_cep_dio.dart';

class ViaCepRepository {
  Future<RetornoViaCepModel> consultarCep(String cepInformado, bool cepJaExisteNaBase) async {
    var dio = ViaCepCustomDio();
    var url = '$cepInformado/json/';
    var result = await dio.api.get(url);

    return RetornoViaCepModel.fromMap(result.data);
  }
}
