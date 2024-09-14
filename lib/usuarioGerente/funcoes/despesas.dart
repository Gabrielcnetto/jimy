import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:jimy/DadosGeralApp.dart';
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
        "urlImageComprovante": "",
        "historicoPagamentos": [],
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
        final pubListaPaga = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("TodasDespesasPagas")
            .doc(despesaCriada.id)
            .set({
          "urlImageComprovante": Dadosgeralapp()
              .defaultAvatarImage, //colocar a imagem que vai ser convertida,
          "historicoPagamentos": [
            DateTime.now(),
          ],
          "pagoDeInicio": despesaCriada.pagoDeInicio,
          "id": despesaCriada.id,
          "name": despesaCriada.name,
          "diaCobranca": despesaCriada.dataDeCobrancaDatetime.day.toString(),
          "mesDeCobranca": despesaCriada.mesDeCobranca,
          "preco": despesaCriada.preco,
          "recorrente": despesaCriada.recorrente,
          "despesaUnica": despesaCriada.despesaUnica,
          "dataDeCobrancaDatetime": despesaCriada.dataDeCobrancaDatetime,
          "momentoFinalizacao": DateTime(2090),
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
      }
      if (isRecorrente == true) {
        final recorrentes = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("despesasRecorrentes")
            .doc(despesaCriada.id)
            .set({
          "urlImageComprovante": "",
          "historicoPagamentos": [],
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

        // Conversão da lista de 'historicoPagamentos' para List<DateTime>
        List<DateTime> historicoPagamentos =
            (data?["historicoPagamentos"] as List<dynamic>?)
                    ?.map((item) => (item as Timestamp).toDate())
                    .toList() ??
                [];

        return Despesa(
          historicoPagamentos: historicoPagamentos,
          urlImageComprovante: data?["urlImageComprovante"] ?? "",
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
    required File fotoUpload,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("comprovantes/${despesaCriada.id}");
      UploadTask uploadTask = ref.putFile(fotoUpload);
      await uploadTask.whenComplete(() => null);
      String imageProfileImage = await ref.getDownloadURL();
      //atualiza na lista princial pra nao mostrar após o pagamento
      final despesas = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("TodasasDespesas")
          .doc(despesaCriada.id)
          .update({
        "momentoFinalizacao": DateTime.now(),
      });
      final ListDatetime = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("TodasasDespesas")
          .doc(despesaCriada.id)
          .update({
        "historicoPagamentos": FieldValue.arrayUnion([DateTime.now()]),
      });
      //aqui salva o valor (soma) ao mes que foi paga a conta, para puxar depois este caminho nos indicadores
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
      String stringPublicavel = imageProfileImage != null
          ? imageProfileImage
          : Dadosgeralapp().defaultAvatarImage;
      //após, envia para essa outra lista que é todas que sao pagas(para puxar)
      try {
        final pubListaPaga = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("TodasDespesasPagas")
            .doc(Random().nextDouble().toString())
            .set({
          "urlImageComprovante":
              stringPublicavel, //colocar a imagem que vai ser convertida,
          "historicoPagamentos": [
            DateTime.now(),
          ],
          "pagoDeInicio": despesaCriada.pagoDeInicio,
          "id": despesaCriada.id,
          "name": despesaCriada.name,
          "diaCobranca": despesaCriada.dataDeCobrancaDatetime.day.toString(),
          "mesDeCobranca": despesaCriada.mesDeCobranca,
          "preco": despesaCriada.preco,
          "recorrente": despesaCriada.recorrente,
          "despesaUnica": despesaCriada.despesaUnica,
          "dataDeCobrancaDatetime": despesaCriada.dataDeCobrancaDatetime,
          "momentoFinalizacao": DateTime(2090),
        });

        final atualizandoListaDePagamentosSeForRecorrente = await database
            .collection("Despesa")
            .doc(idBarbearia)
            .collection("despesasRecorrentes")
            .doc(despesaCriada.id)
            .update({
          "historicoPagamentos": FieldValue.arrayUnion([DateTime.now()]),
        });
      } catch (e) {
        print("salvando na lista 2, deu isto:$e");
      }
    } catch (e) {
      print("no provider ao criar uma despesa recorrente deu isto:$e");
      throw e;
    }
  }

  //get lista total
  List<Despesa> _despesalistCompletaPosPagas = [];
  List<Despesa> get despesaListPosPaga => [..._despesalistCompletaPosPagas];

  final StreamController<List<Despesa>> _despesaListPosPagaStream =
      StreamController<List<Despesa>>.broadcast();

  Stream<List<Despesa>> get getDespesaListPosPaga =>
      _despesaListPosPagaStream.stream;

  Future<void> getDespesasPosPagaLoad() async {
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
          .collection("TodasDespesasPagas")
          .get();

      _despesalistCompletaPosPagas = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        // Conversão da lista de 'historicoPagamentos' para List<DateTime>
        List<DateTime> historicoPagamentos =
            (data?["historicoPagamentos"] as List<dynamic>?)
                    ?.map((item) => (item as Timestamp).toDate())
                    .toList() ??
                [];

        return Despesa(
          historicoPagamentos: historicoPagamentos,
          urlImageComprovante: data?["urlImageComprovante"] ?? "",
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

      _despesalistCompletaPosPagas.sort((a, b) {
        return a.diaCobranca.compareTo(b.diaCobranca);
      });
      _despesaListPosPagaStream.add(_despesalistCompletaPosPagas);
    } catch (e) {
      print("Erro ao carregar as despesas: $e");
    }
  }
}
