import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:jimy/usuarioGerente/classes/Despesa.dart';

class DespesasFunctions with ChangeNotifier {
  final authConfigs = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;

  Future<void> criandoDespesa({
    required Despesa despesaCriada,
    required String idBarbearia,
    required bool isRecorrente,
  }) async {
    try {
      //aqui criando uma recorrente
      final despesas = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("TodasasDespesas")
          .doc(despesaCriada.id)
          .set({
        "pagoDeInicio": despesaCriada.pagoDeInicio,
        "id": despesaCriada.id,
        "name": despesaCriada.name,
        "diaCobranca": despesaCriada.dataDeCobrancaDatetime.day.toString(),
        "mesDeCobranca": despesaCriada.mesDeCobranca,
        "preco": despesaCriada.preco,
        "recorrente": isRecorrente,
        "despesaUnica": isRecorrente == true ? false : true,
        "dataDeCobrancaDatetime": despesaCriada.dataDeCobrancaDatetime,
        "momentoFinalizacao": DateTime(2024),
      });
      if (isRecorrente == false) {
        final valorDespesaUnica = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("historicoDespesas")
            .doc("${despesaCriada.mesDeCobranca}.${DateTime.now().year}");

        final valorDespesasSnapsot = await valorDespesaUnica.get();
        if (valorDespesasSnapsot.exists) {
          // Se o documento existir, use update()
          await valorDespesaUnica.update({
            'valor': FieldValue.increment(despesaCriada.preco),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await valorDespesaUnica.set({
            'valor': FieldValue.increment(despesaCriada.preco),
          }, SetOptions(merge: true));
        }
      }
      if (isRecorrente == true) {
        final recorrentes = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("despesasRecorrentes")
            .doc(despesaCriada.id)
            .set({
          "pagoDeInicio": despesaCriada.pagoDeInicio,
          "id": despesaCriada.id,
          "name": despesaCriada.name,
          "diaCobranca": despesaCriada.dataDeCobrancaDatetime.day.toString(),
          "mesDeCobranca": despesaCriada.mesDeCobranca,
          "preco": despesaCriada.preco,
          "recorrente": isRecorrente,
          "despesaUnica": isRecorrente == true ? false : true,
          "dataDeCobrancaDatetime": despesaCriada.dataDeCobrancaDatetime,
          "momentoFinalizacao": DateTime(2024),
        });
        final valorTotalDespesasRecorrentes = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("valorTotalDespesasRecorrentes")
            .doc("valor");

        final valorDespesasSnapsot = await valorTotalDespesasRecorrentes.get();
        if (valorDespesasSnapsot.exists) {
          // Se o documento existir, use update()
          await valorTotalDespesasRecorrentes.update({
            'valor': FieldValue.increment(despesaCriada.preco),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await valorTotalDespesasRecorrentes.set({
            'valor': FieldValue.increment(despesaCriada.preco),
          }, SetOptions(merge: true));
        }
      }
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
          .collection("TodasasDespesas")
          .get();

      _despesaLista = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        return Despesa(
          pagoDeInicio: data?["pagoDeInicio"] ?? false,
          PagoEsteMes: data?["PagoEsteMes"] ?? false,
          dataDeCobrancaDatetime:
              (data?["dataDeCobrancaDatetime"] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          despesaUnica: data?["despesaUnica"] ?? false,
          diaCobranca: data?["diaCobranca"] ?? '',
          id: data?["id"] ?? '',
          mesDeCobranca: data?["mesDeCobranca"] ?? '',
          momentoFinalizacao:
              (data?["momentoFinalizacao"] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          name: data?["name"] ?? '',
          preco: (data?["preco"] as num?)?.toDouble() ?? 0.0,
          recorrente: data?["recorrente"] ?? false,
        );
      }).toList();
      _despesaLista.sort((a, b) {
        return a.diaCobranca.compareTo(b.diaCobranca);
      });
      despesaList.add(_despesaLista);
    } catch (e) {
      print("Erro ao carregar as despesas: $e");
    }
  }

  Future<void> FinalizandoDespesa({
    required Despesa despesaCriada,
    required String idBarbearia,
 
  }) async {
    try {
      //aqui criando uma recorrente
      final despesas = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("TodasasDespesas")
          .doc(despesaCriada.id)
          .update({
        "momentoFinalizacao": DateTime.now(),
      });
      final valorDespesaUnica = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("historicoDespesas")
          .doc("${despesaCriada.mesDeCobranca}.${DateTime.now().year}");

      final valorDespesasSnapsot = await valorDespesaUnica.get();
      if (valorDespesasSnapsot.exists) {
        // Se o documento existir, use update()
        await valorDespesaUnica.update({
          'valor': FieldValue.increment(despesaCriada.preco),
        });
      } else {
        // Se o documento não existir, use set() com merge: true para criá-lo
        await valorDespesaUnica.set({
          'valor': FieldValue.increment(despesaCriada.preco),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("no provider ao criar uma despesa recorrente deu isto:$e");
      throw e;
    }
  }
}
