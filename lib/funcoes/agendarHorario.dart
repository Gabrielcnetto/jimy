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
          "clienteNome": "BARBANULO",
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
          "horarioSelecionado": corte.horariosExtras[0],
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
          "clienteNome": "BARBANULO",
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
          "horarioSelecionado": corte.horariosExtras[1],
          "diaSelecionado": corte.diaSelecionado,
          "MesSelecionado": corte.MesSelecionado,
          "anoSelecionado": corte.anoSelecionado,
          "dataSelecionadaDateTime": corte.dataSelecionadaDateTime,
          "momentoDoAgendamento": corte.momentoDoAgendamento,
        });
      }
      //enviando os dados/indicadores
      try {
        //enviando dados da barbearia referente ao mes em que o corte foi feito
        final docRef = await database
            .collection("dadosBarbearias")
            .doc(idDaBarbearia)
            .collection("faturamentoMes")
            .doc(monthName);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // Se o documento existir, use update()
          await docRef.update({
            'valor': FieldValue.increment(corte.valorCorte),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await docRef.set({
            'valor': FieldValue.increment(corte.valorCorte),
          }, SetOptions(merge: true));
        }
        //enviando agora a quantidade de faturamento total
        final docRefFaturamentoTotal = await database
            .collection("dadosBarbearias")
            .doc(idDaBarbearia)
            .collection("faturamentoTotal")
            .doc("valor");

        final docSnapshotFaturamentoTotal = await docRefFaturamentoTotal.get();

        if (docSnapshotFaturamentoTotal.exists) {
          // Se o documento existir, use update()
          await docRefFaturamentoTotal.update({
            'valor': FieldValue.increment(corte.valorCorte),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await docRefFaturamentoTotal.set({
            'valor': FieldValue.increment(corte.valorCorte),
          }, SetOptions(merge: true));
        }

        //quantidade de corte feita no mes
        final docRefquantidadeMensaldeCortesFeitos = await database
            .collection("dadosBarbearias")
            .doc(idDaBarbearia)
            .collection("quantiaCortesMesAtual")
            .doc("valor");

        final docSnapshotQuantiaCorteFeitoEsteMes =
            await docRefquantidadeMensaldeCortesFeitos.get();

        if (docSnapshotQuantiaCorteFeitoEsteMes.exists) {
          // Se o documento existir, use update()
          await docRefquantidadeMensaldeCortesFeitos.update({
            'valor': FieldValue.increment(1),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await docRefquantidadeMensaldeCortesFeitos.set({
            'valor': FieldValue.increment(1),
          }, SetOptions(merge: true));
        }

        //enviando agora o total de cortes historico
        final docTotalCortesHistoria = await database
            .collection("dadosBarbearias")
            .doc(idDaBarbearia)
            .collection("totalCortesHistorico")
            .doc("valor");

        final docSnapTotalCorteHistorico = await docTotalCortesHistoria.get();

        if (docSnapTotalCorteHistorico.exists) {
          // Se o documento existir, use update()
          await docTotalCortesHistoria.update({
            'valor': FieldValue.increment(1),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await docTotalCortesHistoria.set({
            'valor': FieldValue.increment(1),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        print("ao enviar os dados deu isto:$e");
      }

      //agora atualizando na classe da barbearia os servicos selecionados, e também o profissional
      try {
        await atualizandoQuantiasNaClasseDaBarbearia(
          idBarbearia: idDaBarbearia,
          profissionalId: corte.profissionalId,
          serviceIdSelecionado: corte.idDoServicoSelecionado,
        );
      } catch (e) {
        print(
            "ao enviar um att ao barbeiro e servico de selecionado deu isto:$e");
      }
      print("acessei a funcao, feito");
    } catch (e) {
      print("ao agendar, houve este erro: ${e}");
      throw e;
    }
    notifyListeners();
  }

  Future<void> atualizandoQuantiasNaClasseDaBarbearia({
    required String idBarbearia,
    required String profissionalId,
    required String serviceIdSelecionado,
  }) async {
    try {
      // Passo 1: Obtenha o documento da barbearia
      DocumentSnapshot documentSnapshot =
          await database.collection('Barbearias').doc(idBarbearia).get();

      if (!documentSnapshot.exists) {
        print('Documento não encontrado!');
        return;
      }

      // Passo 2: Encontre o barbeiro e a lista de profissionais
      List<dynamic> profissionais = documentSnapshot.get('profissionais');
      List<Map<String, dynamic>> updatedProfissionais =
          List.from(profissionais);

      for (int i = 0; i < updatedProfissionais.length; i++) {
        if (updatedProfissionais[i]['id'] == profissionalId) {
          // Verificando se o totalCortes é double ou int e convertendo para int
          int totalCortesAtual =
              (updatedProfissionais[i]['totalCortes'] as num).toInt();
          updatedProfissionais[i]['totalCortes'] = totalCortesAtual + 1;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });

      // Passo 2: Encontre o barbeiro e a lista de profissionais
      List<dynamic> servicos = await documentSnapshot.get('servicos');
      List<Map<String, dynamic>> updateServiceEscolha = await List.from(servicos);

      for (int i = 0; i < updateServiceEscolha.length; i++) {
        if (updateServiceEscolha[i]['id'] == serviceIdSelecionado) {
          // Verificando se o totalCortes é double ou int e convertendo para int
          int quantiaEscolhida =
              (updateServiceEscolha[i]['quantiaEscolhida'] as num).toInt();
          updateServiceEscolha[i]['quantiaEscolhida'] = await quantiaEscolhida + 1;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'servicos': updateServiceEscolha,
      });
      //atualizando agora a quantai do servico selecionado
    } catch (e) {
      print("Erro ao atualizar na classe: $e");
      throw e;
    }
  }

  //
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
