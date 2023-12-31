import 'package:flutter/material.dart';
import 'package:viacep_flutter/model/back4app_model.dart';

import '../../dto/atualizar_dados_dto.dart';
import '../../repositories/back4app/back4app_repository.dart';

class EditarCepPage extends StatefulWidget {
  final Results dadosCep;
  const EditarCepPage({super.key, required this.dadosCep});

  @override
  State<EditarCepPage> createState() => _EditarCepPageState();
}

class _EditarCepPageState extends State<EditarCepPage> {
  bool habilitarMensagemSalvando = false;
  bool habilitarSomenteLeitura = false;
  final repo = Back4AppRepository();
  @override
  Widget build(BuildContext context) {
    final List<ControllerList> listCtrl = [
      ControllerList(
        controller: TextEditingController(text: widget.dadosCep.logradouro),
        keyboardType: TextInputType.text,
        labelText: 'Logradouro',
        nome: 'logradouro',
      ),
      ControllerList(
        controller: TextEditingController(text: widget.dadosCep.complemento),
        keyboardType: TextInputType.text,
        labelText: 'Complemento',
        nome: 'complemento',
      ),
      ControllerList(
        controller: TextEditingController(text: widget.dadosCep.bairro),
        keyboardType: TextInputType.text,
        labelText: 'Bairro',
        nome: 'bairro',
      ),
      ControllerList(
        controller: TextEditingController(text: widget.dadosCep.localidade),
        keyboardType: TextInputType.text,
        labelText: 'Localidade',
        nome: 'localidade',
      ),
      ControllerList(
          controller: TextEditingController(text: widget.dadosCep.ddd),
          keyboardType: TextInputType.number,
          labelText: 'DDD',
          nome: 'ddd'),
      ControllerList(
          controller: TextEditingController(text: widget.dadosCep.gia),
          keyboardType: TextInputType.number,
          labelText: 'Gia',
          nome: 'gia'),
      ControllerList(
          controller: TextEditingController(text: widget.dadosCep.ibge),
          keyboardType: TextInputType.number,
          labelText: 'IBGE',
          nome: 'ibge'),
      ControllerList(
          controller: TextEditingController(text: widget.dadosCep.siafi),
          keyboardType: TextInputType.number,
          labelText: 'SIAFI',
          nome: 'siafi'),
      ControllerList(
          controller: TextEditingController(text: widget.dadosCep.uf),
          keyboardType: TextInputType.text,
          labelText: 'UF',
          nome: 'uf'),
    ];
    List<Widget> listDeInputs() {
      List<Widget> listPadding = [];
      for (var e = 0; e < listCtrl.length; e++) {
        listPadding.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: listCtrl[e].controller,
              readOnly: habilitarSomenteLeitura,
              decoration: InputDecoration(labelText: listCtrl[e].labelText),
              keyboardType: listCtrl[e].keyboardType,
            ),
          ),
        );
      }
      return listPadding;
    }

    String obterValorDoCampo(String nomeCampo) {
      return listCtrl
          .toList()
          .where(
            (element) => element.nome == nomeCampo,
          )
          .first
          .controller
          .text;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CEP: ${widget.dadosCep.cep!}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              exibirMensagemSalvando(true);

              var logradouro = obterValorDoCampo('logradouro');
              var complemento = obterValorDoCampo('complemento');
              var bairro = obterValorDoCampo('bairro');
              var localidade = obterValorDoCampo('localidade');
              var ddd = obterValorDoCampo('ddd');
              var gia = obterValorDoCampo('gia');
              var ibge = obterValorDoCampo('ibge');
              var siafi = obterValorDoCampo('siafi');
              var uf = obterValorDoCampo('uf');

              var dadosParaAtualizar = AtualizarDadosDto(
                cep: widget.dadosCep.cep,
                logradouro: logradouro,
                complemento: complemento,
                bairro: bairro,
                localidade: localidade,
                uf: uf,
                ibge: ibge,
                gia: gia,
                ddd: ddd,
                siafi: siafi,
              );

              await repo.atualizar(dadosParaAtualizar, widget.dadosCep.objectId!);

              exibirMensagemSalvando(false);
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              exibirMensagemSalvando(true);
              await repo.deletar(widget.dadosCep.objectId!);
              exibirMensagemSalvando(false);
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: habilitarMensagemSalvando,
              child: const Text(
                'Salvando...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...listDeInputs(),
          ],
        ),
      ),
    );
  }

  void exibirMensagemSalvando(bool exibir) {
    setState(() {
      habilitarMensagemSalvando = exibir;
      habilitarSomenteLeitura = exibir;
    });
  }
}

class ControllerList {
  TextEditingController controller;
  TextInputType keyboardType;
  String labelText;
  String nome;
  ControllerList({
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    required this.nome,
  });
}
