import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';

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
          .doc(corte.horarioSelecionado)
          .set({
        "id": corte.id,
        "clienteNome": corte.clienteNome,
        "urlImagePerfilfoto": corte.urlImagePerfilfoto,
        //identificacao da barbearia
        "barbeariaId": corte.barbeariaId,

        //identificacao do profissional
        "ProfissionalSelecionado": corte.ProfissionalSelecionado,
        "urlImageProfissionalFoto": corte.urlImageProfissionalFoto,
        "profissionalId": corte.profissionalId,

        //verificacao de pagamento e procedimento
        "valorCorte": corte.valorCorte,
        "preencher2horarios": corte.preencher2horarios,
        "JaCortou": corte.JaCortou,
        "pagoucomcupom": corte.pagoucomcupom,
        "pagouPeloApp": corte.pagouPeloApp,
        "pontosGanhos": corte.pontosGanhos,

        //informacoes do dia e horario
        "idDoServicoSelecionado": corte.idDoServicoSelecionado,
        "nomeServicoSelecionado": corte.nomeServicoSelecionado,
        "horarioSelecionado": corte.horarioSelecionado,
        "diaSelecionado": corte.diaSelecionado,
        "MesSelecionado": corte.MesSelecionado,
        "anoSelecionado": corte.anoSelecionado,
        "dataSelecionadaDateTime": corte.dataSelecionadaDateTime,
        "momentoDoAgendamento": corte.momentoDoAgendamento,
      });
      //adicionado horarios extras, caso o prazo for mais de 1hr
      if (corte.preencher2horarios == true) {
        final pubAgendaGeral = await database
            .collection('agendas')
            .doc(idDaBarbearia)
            .collection("${monthName}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(nomeBarber)
            .doc(corte.horariosExtras[0])
            .set({
          "id": corte.id,
          "clienteNome": "extra",
          "urlImagePerfilfoto": corte.urlImagePerfilfoto,
          //identificacao da barbearia
          "barbeariaId": corte.barbeariaId,

          //identificacao do profissional
          "ProfissionalSelecionado": corte.ProfissionalSelecionado,
          "urlImageProfissionalFoto": corte.urlImageProfissionalFoto,
          "profissionalId": corte.profissionalId,

          //verificacao de pagamento e procedimento
          "valorCorte": corte.valorCorte,
          "preencher2horarios": corte.preencher2horarios,
          "JaCortou": corte.JaCortou,
          "pagoucomcupom": corte.pagoucomcupom,
          "pagouPeloApp": corte.pagouPeloApp,
          "pontosGanhos": corte.pontosGanhos,

          //informacoes do dia e horario
          "idDoServicoSelecionado": corte.idDoServicoSelecionado,
          "nomeServicoSelecionado": corte.nomeServicoSelecionado,
          "horarioSelecionado": corte.horarioSelecionado,
          "diaSelecionado": corte.diaSelecionado,
          "MesSelecionado": corte.MesSelecionado,
          "anoSelecionado": corte.anoSelecionado,
          "dataSelecionadaDateTime": corte.dataSelecionadaDateTime,
          "momentoDoAgendamento": corte.momentoDoAgendamento,
        });
        //colocando o 2
        final pubAgendaGeral2 = await database
            .collection('agendas')
            .doc(idDaBarbearia)
            .collection("${monthName}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(nomeBarber)
            .doc(corte.horariosExtras[1])
            .set({
          "id": corte.id,
          "clienteNome": "extra",
          "urlImagePerfilfoto": corte.urlImagePerfilfoto,
          //identificacao da barbearia
          "barbeariaId": corte.barbeariaId,

          //identificacao do profissional
          "ProfissionalSelecionado": corte.ProfissionalSelecionado,
          "urlImageProfissionalFoto": corte.urlImageProfissionalFoto,
          "profissionalId": corte.profissionalId,

          //verificacao de pagamento e procedimento
          "valorCorte": corte.valorCorte,
          "preencher2horarios": corte.preencher2horarios,
          "JaCortou": corte.JaCortou,
          "pagoucomcupom": corte.pagoucomcupom,
          "pagouPeloApp": corte.pagouPeloApp,
          "pontosGanhos": corte.pontosGanhos,

          //informacoes do dia e horario
          "idDoServicoSelecionado": corte.idDoServicoSelecionado,
          "nomeServicoSelecionado": corte.nomeServicoSelecionado,
          "horarioSelecionado": corte.horarioSelecionado,
          "diaSelecionado": corte.diaSelecionado,
          "MesSelecionado": corte.MesSelecionado,
          "anoSelecionado": corte.anoSelecionado,
          "dataSelecionadaDateTime": corte.dataSelecionadaDateTime,
          "momentoDoAgendamento": corte.momentoDoAgendamento,
        });
       
      }
      print("acessei a funcao, feito");
    } catch (e) {
      print("ao agendar, houve este erro: ${e}");
      throw e;
    }
    notifyListeners();
  }

  List<Horarios> _horariosListLoad = [];
  List<Horarios> get horariosListLoad => [..._horariosListLoad];
  //
  Future<void> loadCortesParaProfissionais({
    required String BarbeariaId,
    required DateTime mesSelecionado,
    required int DiaSelecionado,
    required String Barbeiroselecionado,
  }) async {
    try {
      print("entramos na funcao de load");
      _horariosListLoad.clear();
      await initializeDateFormatting('pt_BR');

      String monthName = DateFormat('MMMM', 'pt_BR').format(mesSelecionado);
      String profissionalNome = Barbeiroselecionado.replaceAll(' ', '');
      print("id barbearia: ${BarbeariaId}");
      print("mes e ano selecionado:${monthName}");
      print("${monthName}.${mesSelecionado.year}");
      print("nome do profissional:${Barbeiroselecionado}");
      print("dia selecionado :${DiaSelecionado}");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("agendas")
          .doc(BarbeariaId)
          .collection("${monthName}.${mesSelecionado.year}")
          .doc('${DiaSelecionado}')
          .collection(profissionalNome)
          .get();

      List<Horarios> horarios = querySnapshot.docs.map((doc) {
        return Horarios(
          quantidadeHorarios: 1,
          horario: doc.id,
          id: "",
        );
      }).toList();

      print("pré for");
      for (var hor in horarios) {
        print("horario da lista preenchido: ${hor.horario}");
      }

      _horariosListLoad = horarios;
      print("este e o tamanho da lista final: ${_horariosListLoad.length}");

      notifyListeners();
    } catch (e) {
      print("erro ao carregar os horários");
      throw e;
    }
  }
}
