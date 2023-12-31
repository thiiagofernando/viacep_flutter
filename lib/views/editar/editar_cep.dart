import 'package:flutter/material.dart';
import 'package:viacep_flutter/model/back4app_model.dart';

class EditarCep extends StatefulWidget {
  final RetornoBack4AppModel dados;
  const EditarCep({super.key, required this.dados});

  @override
  State<EditarCep> createState() => _EditarCepState();
}

class _EditarCepState extends State<EditarCep> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
