import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:friotrim/usuarioGerente/classes/CorteClass.dart';
import 'package:friotrim/usuarioGerente/classes/horarios.dart';

class Agendarhorario with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseFirestore.instance;

  Future<void> agendarHorararioParaProfissionais({
    required String idDaBarbearia,
    required Corteclass corte,
    required double porcentagemProfissional,
  }) async {

    try {
    

      // Obtendo o nome do profissional e o nome do mês
      final String nomeProfissional =
          corte.ProfissionalSelecionado.replaceAll(' ', '');
      final nomeBarber = Uri.encodeFull(nomeProfissional);
      String monthName =
          DateFormat('MMMM', 'pt_BR').format(corte.dataSelecionadaDateTime);
      double valorComissao = corte.valorCorte * (porcentagemProfissional / 100);

      // Publicando na agenda geral
      final pubAgendaGeral = await database
          .collection('agendas')
          .doc(idDaBarbearia)
          .collection("${monthName}.${corte.anoSelecionado}")
          .doc(corte.diaSelecionado)
          .collection(nomeBarber)
          .doc(corte.horarioSelecionado)
          .set({
        "valorQueOProfissionalGanhaPorCortes":
            corte.valorQueOProfissionalGanhaPorCortes,
        "valorQueOProfissionalGanhaPorProdutos":
            corte.valorQueOProfissionalGanhaPorProdutos,
        "id": corte.id,
        "clienteNome": corte.clienteNome,
        "urlImagePerfilfoto": corte.urlImagePerfilfoto,
        "barbeariaId": corte.barbeariaId,
        "ProfissionalSelecionado": corte.ProfissionalSelecionado,
        "urlImageProfissionalFoto": corte.urlImageProfissionalFoto,
        "profissionalId": corte.profissionalId,
        "valorCorte": corte.valorCorte,
        "preencher2horarios": corte.preencher2horarios,
        "JaCortou": corte.JaCortou,
        "pagoucomcupom": corte.pagoucomcupom,
        "pagouPeloApp": corte.pagouPeloApp,
        "pontosGanhos": corte.pontosGanhos,
        "porcentagemDoProfissional": valorComissao,
        "idDoServicoSelecionado": corte.idDoServicoSelecionado,
        "nomeServicoSelecionado": corte.nomeServicoSelecionado,
        "horarioSelecionado": corte.horarioSelecionado,
        "diaSelecionado": corte.diaSelecionado,
        "MesSelecionado": corte.MesSelecionado,
        "anoSelecionado": corte.anoSelecionado,
        "dataSelecionadaDateTime": corte.dataSelecionadaDateTime,
        "horariosExtras":corte.horariosExtras,
      });

      // Verificando se deve preencher 2 horários e se há horários extras disponíveis
      if (corte.preencher2horarios == true) {
       

        // Verifica se há pelo menos 2 horários extras disponíveis
        if (corte.horariosExtras.length >= 2) {
          

          // Publicando o primeiro horário extra
          final pubAgendaGeral1 = await database
              .collection('agendas')
              .doc(idDaBarbearia)
              .collection("${monthName}.${corte.anoSelecionado}")
              .doc(corte.diaSelecionado)
              .collection(nomeBarber)
              .doc(corte.horariosExtras[0])
              .set({
            // Mesmos dados do agendamento principal
            "valorQueOProfissionalGanhaPorCortes":
                corte.valorQueOProfissionalGanhaPorCortes,
            "valorQueOProfissionalGanhaPorProdutos":
                corte.valorQueOProfissionalGanhaPorProdutos,
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

          // Publicando o segundo horário extra
          final pubAgendaGeral2 = await database
              .collection('agendas')
              .doc(idDaBarbearia)
              .collection("${monthName}.${corte.anoSelecionado}")
              .doc(corte.diaSelecionado)
              .collection(nomeBarber)
              .doc(corte.horariosExtras[1])
              .set({
            // Mesmos dados do agendamento principal
            "valorQueOProfissionalGanhaPorCortes":
                corte.valorQueOProfissionalGanhaPorCortes,
            "valorQueOProfissionalGanhaPorProdutos":
                corte.valorQueOProfissionalGanhaPorProdutos,
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
        } else {
       
        }
      } else {

      }
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
          .collection("dadosEsperadosBarbearias")
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
          .collection("dadosEsperadosBarbearias")
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
          isActive: true,
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
  Future<void> apenasDesmarcar({
    required Corteclass corte,
    required String idBarbearia,
  }) async {
    //primeiro remove o caminho antigo => inicio
 
    try {
      //antes de excluir cria um novo => inicio
    bool entrarNoPreencher = await corte.preencher2horarios;
    print("entro? ${entrarNoPreencher}");
      //antes de excluir, cria o novo => fim
      if (entrarNoPreencher == true) {
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
        final remove = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horarioSelecionado)
            .delete();
      } else {
         final remove = await database
            .collection("agendas")
            .doc(idBarbearia)
            .collection("${corte.MesSelecionado}.${corte.anoSelecionado}")
            .doc(corte.diaSelecionado)
            .collection(corte.ProfissionalSelecionado)
            .doc(corte.horarioSelecionado)
            .delete();
      }
    } catch (e) {
      print("deu erro ao apagar o caminho antigo:$e");
      throw e;
    }

    //agora retira a comissao do barbeiro =>fim
  }

  //desmarcar, e criar denovo (alteracao de agendamento)
  Future<void> DesmarcareReagendar({
    required Corteclass corte,
    required Corteclass corte2,
    required String idBarbearia,
  }) async {
    //primeiro remove o caminho antigo => inicio
 
    try {
      //antes de excluir cria um novo => inicio
      await agendarHorararioParaProfissionais2ParaRemarcacao(
        corte: corte2,
        idDaBarbearia: idBarbearia,
        ValorFinalComissao: corte2.porcentagemDoProfissional,
      );
      //antes de excluir, cria o novo => fim
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
      print("ao tirar a comissao do profissional, deu isto:$e");
    }
    //agora retira a comissao do barbeiro =>fim
  }

  //fundao de criar para quando é remarcacao
  Future<void> agendarHorararioParaProfissionais2ParaRemarcacao({
    required String idDaBarbearia,
    required Corteclass corte,
    required double ValorFinalComissao,
  }) async {
    try {
      print("acessei a funcao");
      //enviando para a agenda
      final String nomeProfissional =
          corte.ProfissionalSelecionado.replaceAll(' ', '');
      final nomeBarber = Uri.encodeFull(nomeProfissional);
      String monthName =
          DateFormat('MMMM', 'pt_BR').format(corte.dataSelecionadaDateTime);
      double valorComissao = ValorFinalComissao;
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
        "porcentagemDoProfissional": valorComissao,
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
    } catch (e) {
      print("ao agendar, houve este erro: ${e}");
      throw e;
    }
    notifyListeners();
  }
}
