import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/classes/comanda.dart';

class Finalizarecarregarcomandas with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authConfigs = FirebaseAuth.instance;

  Future<void> finalizandoComanda({
    required Comanda comanda,
    required String idBarbearia,
    required Corteclass corte,
  }) async {
    try {
      // Converte os serviços e produtos em mapas
      final servicosMap =
          comanda.servicosFeitos.map((servico) => servico.toMap()).toList();
      final produtosMap =
          comanda.produtosVendidos.map((produto) => produto.toMap()).toList();

      await FirebaseFirestore.instance
          .collection("comandas")
          .doc(idBarbearia)
          .collection("todasascomandas")
          .doc(comanda.id)
          .set(
        {
          "nomeCliente": comanda.nomeCliente,
          "idBarbearia": idBarbearia,
          "idBarbeiroQueCriou": comanda.idBarbeiroQueCriou,
          "valorTotalComanda": comanda.valorTotalComanda,
          "dataFinalizacao": comanda.dataFinalizacao.toIso8601String(),
          "servicosFeitos": FieldValue.arrayUnion(servicosMap),
          "produtosVendidos": produtosMap,
        },
        SetOptions(merge: true),
      );

      //ativando o "jacortou"
      try {
        final attJaCortou = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horarioSelecionado)
            .update({
          "JaCortou": true,
        });
        //removendo o 2
        final attJaCortou2 = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horariosExtras[0])
            .delete();
        final attJaCortou3 = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horariosExtras[1])
            .delete();
      } catch (e) {
        print("erro ao mudar o ja cortou :$e");
        throw e;
      }
    } catch (e) {
      print("Erro ao finalizar comanda: $e");
      throw e;
    }
  }
}
