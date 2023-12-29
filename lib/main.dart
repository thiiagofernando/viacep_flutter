import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    return MaterialApp(
      title: 'Consulta de CEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
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
  String mensagemAguarde = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          children: <Widget>[
            Text(
              mensagemAguarde,
            ),
            const Text(
              'CEPs Cadastrados',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            mensagemAguarde = 'Consultando....';
          });
          var repo = ViaCepRepository();
          var backRepo = Back4AppRepository();
          var consulta = await repo.consultarCep('78150322');
          var backConsulta = await backRepo.obterTodos();
          debugPrint(consulta.toString());
          debugPrint(backConsulta.results!.first.toString());
          setState(() {
            mensagemAguarde = '';
          });
        },
        tooltip: 'Sincronizar',
        child: const Icon(Icons.sync_alt_outlined),
      ),
    );
  }
}
