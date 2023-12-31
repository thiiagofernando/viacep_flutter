import 'package:flutter/material.dart';
import 'package:viacep_flutter/model/back4app_model.dart';

class EditarCepPage extends StatefulWidget {
  final Results dadosCep;
  const EditarCepPage({super.key, required this.dadosCep});

  @override
  State<EditarCepPage> createState() => _EditarCepPageState();
}

class _EditarCepPageState extends State<EditarCepPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController logradouroCtrl = TextEditingController(text: widget.dadosCep.logradouro);
    final TextEditingController complementoCtrl = TextEditingController(text: widget.dadosCep.complemento);

    return Scaffold(
      appBar: AppBar(
        title: Text('CEP: ${widget.dadosCep.cep!}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              print(logradouroCtrl.text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              print(logradouroCtrl.text);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: logradouroCtrl,
                decoration: const InputDecoration(labelText: 'Logradouro'),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: complementoCtrl,
                decoration: const InputDecoration(labelText: 'Complemento'),
                keyboardType: TextInputType.text,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Bairro'),
                keyboardType: TextInputType.text,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Localidade'),
                keyboardType: TextInputType.text,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'UF'),
                keyboardType: TextInputType.text,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'IBGE'),
                keyboardType: TextInputType.number,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'GIA'),
                keyboardType: TextInputType.number,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'DDD'),
                keyboardType: TextInputType.number,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Siafi'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
