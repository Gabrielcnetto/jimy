import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';

class Agendarhorario with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseFirestore.instance;

  Future<void> agendarHorararioParaProfissionais({
    required String idDaBarbearia,
    required Corteclass corte,
  }) async {
    try {
      print("acessei a funcao");
      //enviando para a agenda
      final String nomeProfissional =
          corte.ProfissionalSelecionado.replaceAll(' ', '');
      final nomeBarber = Uri.encodeFull(nomeProfissional);
          String monthName =
         DateFormat('MMMM', 'pt_BR').format(corte.dataSelecionadaDateTime);
      final pubAgendaGeral = await database
          .collection('agendas')
          .doc(idDaBarbearia)
          .collection("${monthName}.${corte.anoSelecionado}")
          .doc(corte.diaSelecionado)
          .collection(nomeBarber)
          .doc(corte.horarioSelecionado); //colocar o .add
           print("acessei a funcao, feito");
    } catch (e) {
      print("ao agendar, houve este erro: ${e}");
      throw e;
    }
    notifyListeners();
  }
}
