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
    required double valorTotalServicos,
    required double valorTotalProdutos,
    required double valorTotalComanda,
    required double porcentagemGanhaProfissionalCortes,
    required double porcentagemGanhaProfissionalProdutos,
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

      //PARTE 2
      //agora atualizando a porcentagem de cortes e ganhos da barbearia(faturamento)e comissoes(profissionais)
      try {
        //enviando dados da barbearia referente ao mes em que o corte foi feito
        final docRef = await database
            .collection("DadosConcretosBarbearias")
            .doc(idBarbearia)
            .collection("faturamentoMes")
            .doc(corte.MesSelecionado);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // Se o documento existir, use update()
          await docRef.update({
            'valor': FieldValue.increment(valorTotalComanda),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await docRef.set({
            'valor': FieldValue.increment(valorTotalComanda),
          }, SetOptions(merge: true));
        }
        //enviando agora a quantidade de faturamento total
        final docRefFaturamentoTotal = await database
            .collection("DadosConcretosBarbearias")
            .doc(idBarbearia)
            .collection("faturamentoTotal")
            .doc("valor");

        final docSnapshotFaturamentoTotal = await docRefFaturamentoTotal.get();

        if (docSnapshotFaturamentoTotal.exists) {
          // Se o documento existir, use update()
          await docRefFaturamentoTotal.update({
            'valor': FieldValue.increment(valorTotalComanda),
          });
        } else {
          // Se o documento não existir, use set() com merge: true para criá-lo
          await docRefFaturamentoTotal.set({
            'valor': FieldValue.increment(valorTotalComanda),
          }, SetOptions(merge: true));
        }

        //quantidade de corte feita no mes
        final docRefquantidadeMensaldeCortesFeitos = await database
            .collection("DadosConcretosBarbearias")
            .doc(idBarbearia)
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
            .collection("DadosConcretosBarbearias")
            .doc(idBarbearia)
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
          idBarbearia: idBarbearia,
          profissionalId: corte.profissionalId,
          serviceIdSelecionado: corte.idDoServicoSelecionado,
        );

        try {
          //enviando a porcentagem ao profissional selecionado
          await enviandoPorcentagensDeComissao(
            valorProdutos: valorTotalProdutos,
            idBarbearia: idBarbearia,
            ProfissionalId: corte.profissionalId,
            mesAtual: corte.MesSelecionado,
            porcentagemProfissionalProdutos: porcentagemGanhaProfissionalProdutos,
            porcentagemProfissionalCortes: porcentagemGanhaProfissionalCortes,
            valorServico: corte.valorCorte,
          );
        } catch (e) {
          print("erro:$e");
        }
      } catch (e) {
        print(
            "ao enviar um att ao barbeiro e servico de selecionado deu isto:$e");
      }
    } catch (e) {
      print("Erro ao finalizar comanda: $e");
      throw e;
    }
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
    required double porcentagemProfissionalCortes,
     required double porcentagemProfissionalProdutos,
    required String idBarbearia,
    required String ProfissionalId,
    required String mesAtual,
    required double valorServico,
    required double valorProdutos,
  }) async {
    try {
      double valorComissaoCortes = await valorServico * (porcentagemProfissionalCortes / 100);
    double valorComissaoProdutos = await valorProdutos * (porcentagemProfissionalProdutos / 100);
    double ValoFinalEnviado = (valorComissaoCortes + valorComissaoProdutos);
      print("#2 o valor final:${ValoFinalEnviado}");
      final pubValorparaProfissional = await database
          .collection("DadosConcretosBarbearias")
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
          'valor': FieldValue.increment(ValoFinalEnviado),
        });
      } else {
        // Se o documento não existir, use set() com merge: true para criá-lo
        await pubValorparaProfissional.set({
          'valor': FieldValue.increment(ValoFinalEnviado),
        }, SetOptions(merge: true));
      }

      await enviandoeSomandoComissaoQueDevePagarACadaProfissional(
        comissaoTotalfinal: ValoFinalEnviado,
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
          .collection("DadosConcretosBarbearias")
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
}
