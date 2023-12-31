import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:viacep_flutter/model/back4app_model.dart';
import 'package:viacep_flutter/model/via_cep_model.dart';
import 'package:viacep_flutter/repositories/via_cep/via_cep_repository.dart';
import 'repositories/back4app/back4app_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  var backRepo = Back4AppRepository();
  var repo = ViaCepRepository();

  String mensagemAguarde = 'Consultando Aguarde!!....';
  String mensagemAlerta = 'Informe um numero de CEP com 8 dígitos';
  final cepCtrl = TextEditingController();
  bool habilitarBotaoConsulta = false;
  bool habilitarMensagemAguarde = false;
  RetornoViaCepModel? consultaViaCep;
  RetornoBack4AppModel retornoBack4App = RetornoBack4AppModel(results: []);
  @override
  void initState() {
    buscarDados();
    super.initState();
  }

  Future<void> buscarDados() async {
    atualizarTela(true, false);
    var consultaDadosExistentes = await backRepo.obterTodos();
    setState(() {
      retornoBack4App = consultaDadosExistentes;
    });
    atualizarTela(false, false);
  }

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
                    atualizarTela(false, true);
                  } else {
                    atualizarTela(false, false);
                  }
                },
                onEditingComplete: () {
                  if (cepCtrl.text.trim().length < 8 || cepCtrl.text.trim().length > 8) {
                    atualizarTela(false, false);
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
                        await pesquisarCep();
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
              Text('Total de CEP Cadastrados ${retornoBack4App.results.length}'),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: retornoBack4App.results.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print('Clicou');
                    },
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primary,
                      child: SizedBox(
                        width: 300,
                        height: 80,
                        child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              retornoBack4App.results[index].toString(),
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pesquisarCep() async {
    atualizarTela(true, false);
    consultaViaCep = await repo.consultarCep(cepCtrl.text, cepJaExiste());
    await recarregarLista();
    atualizarTela(false, true);
  }

  Future<void> recarregarLista() async {
    retornoBack4App = await backRepo.obterTodos();
  }

  bool cepJaExiste() {
    return retornoBack4App.results.where((c) => c.cep == cepCtrl.text).isEmpty;
  }

  void atualizarTela(bool mensagemAguarde, bool botaoConsulta) {
    setState(() {
      habilitarMensagemAguarde = mensagemAguarde;
      habilitarBotaoConsulta = botaoConsulta;
    });
  }
}
