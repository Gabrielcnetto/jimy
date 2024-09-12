import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:jimy/usuarioGerente/classes/Despesa.dart';

class DespesasFunctions with ChangeNotifier {
  final authConfigs = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;

  Future<void> criandoUmaDespesaRecorrenteESalvando({
    required Despesa despesaCriada,
    required String idBarbearia,
  }) async {
    try {
      final despesas = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("DespesaRecorrente")
          .doc(despesaCriada.id)
          .set({
        "id": despesaCriada.id,
        "name": despesaCriada.name,
        "diaCobranca": despesaCriada.dataDeCobrancaDatetime.day.toString(),
        "mesDeCobranca": despesaCriada.mesDeCobranca,
        "preco": despesaCriada.preco,
        "recorrente": despesaCriada.recorrente,
        "despesaUnica": false,
        "dataDeCobrancaDatetime": despesaCriada.dataDeCobrancaDatetime,
        "momentoFinalizacao": DateTime.now(),
      });
    } catch (e) {
      print("no provider ao criar uma despesa recorrente deu isto:$e");
      throw e;
    }
  }

  //get das despesas
  List<Despesa> _despesaLista = [];
  List<Despesa> get despesaLista => [..._despesaLista];

  final StreamController<List<Despesa>> despesaList =
      StreamController<List<Despesa>>.broadcast();

  Stream<List<Despesa>> get getDespesaList => despesaList.stream;

  Future<void> getDespesasLoad() async {
  try {
    final String uidUser = await authConfigs.currentUser!.uid;
    String? userIdbarbearia;

    await database.collection("usuarios").doc(uidUser).get().then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        userIdbarbearia = data['idBarbearia'];
      }
      return userIdbarbearia;
    });

    QuerySnapshot querySnapshot = await database
        .collection("Despesa")
        .doc(userIdbarbearia)
        .collection("DespesaRecorrente")
        .get();

    _despesaLista = querySnapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      
      return Despesa(
        PagoEsteMes: data?["PagoEsteMes"] ?? false,
        dataDeCobrancaDatetime: (data?["dataDeCobrancaDatetime"] as Timestamp?)?.toDate() ?? DateTime.now(),
        despesaUnica: data?["despesaUnica"] ?? false,
        diaCobranca: data?["diaCobranca"] ?? '',
        id: data?["id"] ?? '',
        mesDeCobranca: data?["mesDeCobranca"] ?? '',
        momentoFinalizacao: (data?["momentoFinalizacao"] as Timestamp?)?.toDate() ?? DateTime.now(),
        name: data?["name"] ?? '',
        preco: (data?["preco"] as num?)?.toDouble() ?? 0.0,
        recorrente: data?["recorrente"] ?? false,
      );
    }).toList();

    despesaList.add(_despesaLista);
  } catch (e) {
    print("Erro ao carregar as despesas: $e");
  }
}

}
