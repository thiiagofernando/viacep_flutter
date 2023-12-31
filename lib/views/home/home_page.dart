import 'package:flutter/material.dart';

import '../../model/back4app_model.dart';
import '../../model/via_cep_model.dart';
import '../../repositories/back4app/back4app_repository.dart';
import '../../repositories/via_cep/via_cep_repository.dart';
import '../editar/editar_cep_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        actions: [
          ElevatedButton(
            child: const Icon(Icons.sync),
            onPressed: () {
              buscarDados();
            },
          ),
        ],
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
                    elevation: 0,
                    color: Theme.of(context).colorScheme.primary,
                    child: SizedBox(
                      width: 350,
                      height: 80,
                      child: Container(
                          padding: const EdgeInsets.all(15.0),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarCepPage(
                            dadosCep: retornoBack4App.results[index],
                          ),
                        ),
                      );
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
    return retornoBack4App.results.where((c) => c.cep?.replaceAll('-', '') == cepCtrl.text).isEmpty;
  }

  void atualizarTela(bool mensagemAguarde, bool botaoConsulta) {
    setState(() {
      habilitarMensagemAguarde = mensagemAguarde;
      habilitarBotaoConsulta = botaoConsulta;
    });
  }
}
