import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';

class Criarservicos with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  Future<void> addServico({
    required String serviceName,
    required double servicePrice,
    required int tempoParaFazer,
    required String idBarbearia,
  }) async {
    try {
      final service = Servico(
        active: false,
        id: Random().nextDouble().toString(),
        name: serviceName,
        price: servicePrice,
        tempolevado: tempoParaFazer,
      );
      final pubNewService =
          database.collection("Barbearias").doc(idBarbearia).update({
        "servicos": FieldValue.arrayUnion([service.toMap()]),
      });
    } catch (e) {
      print("erro ao adicionar serviço");
      throw e;
    }
  }
}
