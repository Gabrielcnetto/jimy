import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friotrim/usuarioGerente/classes/servico.dart';

class Criarservicos with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;
  Future<void> addServico({
    required String serviceName,
    required double servicePrice,
    required bool ocupar2Vagas,
    required String idBarbearia,
  }) async {
    try {
      final service = Servico(
        quantiaEscolhida: 0,
        active: false,
        id: Random().nextDouble().toString(),
        name: serviceName,
        price: servicePrice,
        ocupar2vagas: ocupar2Vagas,
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

  Future<void> removerServico({required Servico service}) async {
    try {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userIdbarbearia;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userIdbarbearia = data['idBarbearia'];
        } else {}
        return userIdbarbearia;
      });

      final removeservice =
          database.collection("Barbearias").doc(userIdbarbearia).update({
        "servicos": FieldValue.arrayRemove([service.toMap()]),
      });
    } catch (e) {
      print("ao remover o serviço deu isso:$e");
    }
  }
}
