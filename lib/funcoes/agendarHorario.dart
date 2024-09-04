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
    required double porcentagemProfissional,
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
        "porcentagemDoProfissional": corte.porcentagemDoProfissional,
        //informacoes do dia e horario
        "idDoServicoSelecionado": corte.idDoServicoSelecionado,
        "nomeServicoSelecionado": corte.nomeServicoSelecionado,
        "horarioSelecionado": corte.horarioSelecionado,
        "diaSelecionado": corte.diaSelecionado,
        "MesSelecionado": corte.MesSelecionado,
        "anoSelecionado": corte.anoSelecionado,
        "dataSelecionadaDateTime": corte.dataSelecionadaDateTime,
        "momentoDoAgendamento": corte.momentoDoAgendamento,
        "horariosExtras": [
          corte.horariosExtras[0],
          corte.horariosExtras[1],
        ],
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

        try {
          //enviando a porcentagem ao profissional selecionado
          await enviandoPorcentagensDeComissao(
            idBarbearia: idDaBarbearia,
            ProfissionalId: corte.profissionalId,
            mesAtual: monthName,
            porcentagemProfissional: porcentagemProfissional,
            valorServico: corte.valorCorte,
          );
        } catch (e) {
          print("erro:$e");
        }
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
      List<Map<String, dynamic>> updateServiceEscolha =
          await List.from(servicos);

      for (int i = 0; i < updateServiceEscolha.length; i++) {
        if (updateServiceEscolha[i]['id'] == serviceIdSelecionado) {
          // Verificando se o totalCortes é double ou int e convertendo para int
          int quantiaEscolhida =
              (updateServiceEscolha[i]['quantiaEscolhida'] as num).toInt();
          updateServiceEscolha[i]['quantiaEscolhida'] =
              await quantiaEscolhida + 1;
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

  Future<void> enviandoPorcentagensDeComissao({
    required double porcentagemProfissional,
    required String idBarbearia,
    required String ProfissionalId,
    required String mesAtual,
    required double valorServico,
  }) async {
    try {
      double valorComissao = valorServico * (porcentagemProfissional / 100);
      print("#2 o valor final:${valorComissao}");
      final pubValorparaProfissional = await database
          .collection("dadosBarbearias")
          .doc(idBarbearia)
          .collection("comissaoMensalBarbeiros")
          .doc(ProfissionalId)
          .collection(mesAtual)
          .doc("dados");

      final docSnapshotQuantiaCorteFeitoEsteMes =
          await pubValorparaProfissional.get();

      if (docSnapshotQuantiaCorteFeitoEsteMes.exists) {
        // Se o documento existir, use update()
        await pubValorparaProfissional.update({
          'valor': FieldValue.increment(valorComissao),
        });
      } else {
        // Se o documento não existir, use set() com merge: true para criá-lo
        await pubValorparaProfissional.set({
          'valor': FieldValue.increment(valorComissao),
        }, SetOptions(merge: true));
      }

      await enviandoeSomandoComissaoQueDevePagarACadaProfissional(
        comissaoTotalfinal: valorComissao,
        idBarbearia: idBarbearia,
        mes: mesAtual,
      );
    } catch (e) {
      print("ao enviar porcentagens, deu isto:$e");
      throw e;
    }
  }

  Future<void> enviandoeSomandoComissaoQueDevePagarACadaProfissional(
      {required String idBarbearia,
      required double comissaoTotalfinal,
      required String mes}) async {
    try {
      final pubFinalComissiao = database
          .collection("dadosBarbearias")
          .doc(idBarbearia)
          .collection("comissaoTotalGerenteMes")
          .doc(mes);
      final docAttComissaoDistribuicao = await pubFinalComissiao.get();

      if (docAttComissaoDistribuicao.exists) {
        // Se o documento existir, use update()
        await pubFinalComissiao.update({
          'valor': FieldValue.increment(comissaoTotalfinal),
        });
      } else {
        // Se o documento não existir, use set() com merge: true para criá-lo
        await pubFinalComissiao.set({
          'valor': FieldValue.increment(comissaoTotalfinal),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("ao enviar a porcentagm total do gerente:$e");
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

  //mudar o dia do agendamento
  Future<void> DesmarcarTotalFuncao({
    required Corteclass corte,
    required String idBarbearia,
  }) async {
    //primeiro remove o caminho antigo => inicio
    print("horario extra 1:${corte.horariosExtras[0]}");
    print("horario extra 2:${corte.horariosExtras[1]}");
    try {
      if (corte.preencher2horarios) {
        final remove2 = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horariosExtras[0])
            .delete();
        final remove3 = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horariosExtras[1])
            .delete();
      }
      final remove = await database
          .collection("agendas")
          .doc(idBarbearia)
          .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
          .doc(corte.diaSelecionado)
          .collection(corte.ProfissionalSelecionado)
          .doc(corte.horarioSelecionado)
          .delete();
    } catch (e) {
      print("deu erro ao apagar o caminho antigo:$e");
      throw e;
    }
    //primeiro remove o caminho antigo => fim

    //Agora retira a comissao do barbeiro => inicio
    try {
      final attComissaoProfissional = await database
          .collection("dadosBarbearias")
          .doc(idBarbearia)
          .collection("comissaoMensalBarbeiros")
          .doc(corte.profissionalId)
          .collection(corte.MesSelecionado)
          .doc("dados")
          .update({
        "valor": FieldValue.increment(-corte.porcentagemDoProfissional),
      });

      //e aqui aproveita para tirar a comissao da aba que o gerente visualiza
      final attComissaoGerente = await database
          .collection("dadosBarbearias")
          .doc(idBarbearia)
          .collection("comissaoTotalGerenteMes")
          .doc(corte.MesSelecionado)
          .update({
        "valor": FieldValue.increment(-corte.porcentagemDoProfissional),
      });
    } catch (e) {
      print("ao tirar a comissao do profissional, deu isto:$e");
    }
    //agora retira a comissao do barbeiro =>fim
  }
}
