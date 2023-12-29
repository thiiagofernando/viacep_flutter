import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:viacep_flutter/model/via_cep_model.dart';
import 'package:viacep_flutter/repositories/via_cep/via_cep_repository.dart';

import 'repositories/back4app/back4app_repository.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta de CEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Consulta de CEP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String mensagemAguarde = 'Consultando Aguarde!!....';
  String mensagemAlerta = 'Informe um numero de CEP com 8 dígitos';
  final cepCtrl = TextEditingController();
  bool habilitarBotaoConsulta = false;
  bool habilitarMensagemAguarde = false;
  RetornoViaCepModel? consultaViaCep;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Visibility(
                visible: habilitarMensagemAguarde,
                child: Text(
                  mensagemAguarde,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              TextField(
                controller: cepCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Informe o CEP',
                  suffixIcon: Icon(Icons.keyboard),
                ),
                onChanged: (value) {
                  if (cepCtrl.text.trim().length == 8) {
                    setState(() {
                      habilitarBotaoConsulta = true;
                    });
                  } else {
                    setState(() {
                      habilitarBotaoConsulta = false;
                    });
                  }
                },
                onEditingComplete: () {
                  if (cepCtrl.text.trim().length < 8 || cepCtrl.text.trim().length > 8) {
                    mensagemInfo();
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(right: 114, left: 114),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: habilitarBotaoConsulta
                    ? () async {
                        setState(() {
                          habilitarMensagemAguarde = true;
                          habilitarBotaoConsulta = false;
                        });
                        var repo = ViaCepRepository();
                        var backRepo = Back4AppRepository();
                        consultaViaCep = await repo.consultarCep(cepCtrl.text);
                        var backConsulta = await backRepo.obterTodos();
                        debugPrint(backConsulta.results!.first.toString());
                        setState(() {
                          habilitarMensagemAguarde = false;
                          habilitarBotaoConsulta = true;
                        });
                      }
                    : null,
                child: const Text("CONSULTAR"),
              ),
              Visibility(
                visible: !habilitarBotaoConsulta && !habilitarMensagemAguarde,
                child: Text(
                  mensagemAlerta,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              Visibility(
                visible: consultaViaCep != null,
                child: Center(
                  child: Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.primary,
                    child: SizedBox(
                      width: 400,
                      height: 100,
                      child: Center(
                          child: Text(
                        consultaViaCep.toString(),
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('CEP Cadastrados'),
              const SizedBox(
                height: 15,
              ),
              ListView(
                shrinkWrap: true,
                children: const [
                  Text('1'),
                  Text('1'),
                  Text('1'),
                  Text('1'),
                  Text('1'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mensagemInfo() {
    Get.snackbar(
      'Atenção',
      mensagemAlerta,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 8),
    );
  }
}
