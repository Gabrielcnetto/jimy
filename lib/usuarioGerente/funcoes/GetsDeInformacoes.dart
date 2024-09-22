import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/CorteClass.dart';
import 'package:fiotrim/usuarioGerente/classes/barbeiros.dart';
import 'package:fiotrim/usuarioGerente/classes/comanda.dart';
import 'package:fiotrim/usuarioGerente/classes/horarios.dart';
import 'package:fiotrim/usuarioGerente/classes/produto.dart';
import 'package:fiotrim/usuarioGerente/classes/servico.dart';

class Getsdeinformacoes with ChangeNotifier {
  final authSettings = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;

  Future<String?> getUserURLImage() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['urlPerfilImage'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  //
  Future<String?> getNomeBarbearia() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['nomeBarbearia'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  //
  Future<String?> getNomeProfissional() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['userName'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  Future<String?> getDescricaoBarbearia() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarberaria = data['idBarbearia'];
        }
      });

      print("toa qui");

      if (idBarberaria == null) {
        return null; // Se o idBarbearia não foi encontrado, retorne null
      }

      String? descricaoBarbearia;

      // Pega a descrição da barbearia
      await database
          .collection("Barbearias")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          print("encontamos algo");
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          descricaoBarbearia = data['descricaoBarbearia'];
          print("encontamos algo: $descricaoBarbearia");
        } else {
          print("isso nao existe");
        }
      });

      return descricaoBarbearia;
    } catch (e) {
      print("ao pegar a descricaoDaBarbeariaDeuIsto: $e");
      return null; // Retorna null em caso de erro
    }
  }

  Future<String?> getNomeIdBarbearia() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['idBarbearia'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  //
  Future<String?> getsenha() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['senha'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  //get dos profissionais para o ranking
  List<Barbeiros> _profList = [];
  List<Barbeiros> get profList => [..._profList];

  final StreamController<List<Barbeiros>> profissionaisList =
      StreamController<List<Barbeiros>>.broadcast();

  Stream<List<Barbeiros>> get getProfissionais => profissionaisList.stream;

  Future<void> getListaProfissionais() async {
    try {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userIdbarbearia;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userIdbarbearia = data['idBarbearia'];
        } else {}
        return userIdbarbearia;
      });
      // Referência ao documento com o ID específico
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('Barbearias')
          .doc(userIdbarbearia);

      // Obtém o documento
      final DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Extrai o campo 'profissionais' que é uma lista de mapas
        final List<dynamic> profissionaisListData =
            docSnapshot.get('profissionais') ?? [];

        // Mapeia os dados para uma lista de Barbeiros
        final List<Barbeiros> barbeirosList = profissionaisListData
            .map((item) => Barbeiros.fromMap(item as Map<String, dynamic>))
            .toList();

        // Atualiza a lista local e notifica os ouvintes
        barbeirosList.sort((a, b) => b.totalCortes.compareTo(a.totalCortes));
        _profList = barbeirosList;
        profissionaisList.add(_profList);
        print("o tamanho final é:${_profList.length}");
      } else {
        print("Documento não encontrado.");
      }
    } catch (e) {
      print("Erro ao carregar os profissionais: $e");
    }
  }

  //get de servicos
  List<Servico> _serviceList = [];
  List<Servico> get serviceList => [..._serviceList];

  final StreamController<List<Servico>> serviceListStream =
      StreamController<List<Servico>>.broadcast();

  Stream<List<Servico>> get getServiceList => serviceListStream.stream;

  Future<void> getListaServicos() async {
    try {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userIdbarbearia;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userIdbarbearia = data['idBarbearia'];
        } else {}
        return userIdbarbearia;
      });
      // Referência ao documento com o ID específico
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('Barbearias')
          .doc(userIdbarbearia);

      // Obtém o documento
      final DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Extrai o campo 'profissionais' que é uma lista de mapas
        final List<dynamic> profissionaisListData =
            docSnapshot.get('servicos') ?? [];

        // Mapeia os dados para uma lista de Servico
        final List<Servico> servicoLista = profissionaisListData
            .map((item) => Servico.fromMap(item as Map<String, dynamic>))
            .toList();
        _serviceList.sort((a, b) => b.price.compareTo(a.price));
        _serviceList = servicoLista;

        serviceListStream.add(_serviceList);

        print("o tamanho final é:${_serviceList.length}");
        print(_serviceList[0].name);
      } else {
        print("Documento não encontrado.");
      }
    } catch (e) {
      print("Erro ao carregar os profissionais: $e");
    }
  }

  final StreamController<List<Corteclass>> _CorteslistaManager =
      StreamController<List<Corteclass>>.broadcast();

  Stream<List<Corteclass>> get CorteslistaManager => _CorteslistaManager.stream;

  List<Corteclass> _managerListCortes = [];
  List<Corteclass> get managerListCortes => [..._managerListCortes];
  Future<void> carregarAgendaAposSelecionarDiaEprofissional({
    required int selectDay,
    required String selectMonth,
    required String proffName,
    required int year,
  }) async {
    print("tela do manager, 7 dias corte funcao executada");

    try {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userIdbarbearia;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userIdbarbearia = data['idBarbearia'];
        } else {}
        return userIdbarbearia;
      });
      print("peguei o profissional:${proffName}");
      // _CorteslistaManager.sink.add([]); // Isso irá enviar uma lista vazia para o fluxo
      final nomeBarber = proffName.replaceAll(' ', '');
      QuerySnapshot querySnapshot = await database
          .collection("agendas")
          .doc(userIdbarbearia)
          .collection("${selectMonth}.${year}")
          .doc("${selectDay}")
          .collection(nomeBarber)
          .get();

      _managerListCortes = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        print(data?["totalValue"].toString());
        return Corteclass(
          valorQueOProfissionalGanhaPorCortes:
              data?["valorQueOProfissionalGanhaPorCortes"] ?? 0.0,
          valorQueOProfissionalGanhaPorProdutos:
              data?["valorQueOProfissionalGanhaPorProdutos"] ?? 0.0,
          porcentagemDoProfissional: data?["porcentagemDoProfissional"] ?? 0.0,
          JaCortou: data?["JaCortou"] ?? false,
          MesSelecionado: data?["MesSelecionado"] ?? "",
          ProfissionalSelecionado: data?["ProfissionalSelecionado"] ?? "",
          anoSelecionado: data?["anoSelecionado"] ?? "",
          barbeariaId: data?["barbeariaId"] ?? "",
          clienteNome: data?["clienteNome"] ?? "",
          dataSelecionadaDateTime:
              (data?["dataSelecionadaDateTime"] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          diaSelecionado: data?["diaSelecionado"] ?? "",
          horarioSelecionado: data?["horarioSelecionado"] ?? "",
          id: data?["id"] ?? "",
          horariosExtras: List<String>.from(data?["horariosExtras"] ?? []),
          idDoServicoSelecionado: data?["idDoServicoSelecionado"] ?? "",
          momentoDoAgendamento:
              (data?["momentoDoAgendamento"] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          nomeServicoSelecionado: data?["nomeServicoSelecionado"] ?? "",
          pagouPeloApp: data?["pagouPeloApp"] ?? false,
          pagoucomcupom: data?["pagoucomcupom"] ?? false,
          pontosGanhos: data?["pontosGanhos"] ?? 0,
          preencher2horarios: data?["preencher2horarios"] ?? false,
          profissionalId: data?["profissionalId"] ?? false,
          urlImagePerfilfoto:
              data?["urlImagePerfilfoto"] ?? Dadosgeralapp().defaultAvatarImage,
          urlImageProfissionalFoto: data?["urlImageProfissionalFoto"] ??
              Dadosgeralapp().defaultAvatarImage,
          valorCorte: data?["valorCorte"] ?? 0.0,
        );
      }).toList();
      _CorteslistaManager.add(_managerListCortes);
    } catch (e) {
      print("ao carregar a lista do manager dia, deu isto: ${e}");
    }
    print("o tamanho da lista é manager ${_managerListCortes.length}");
    notifyListeners();
  }

  //coisas relacionadas aos indicadores da home - inicio
  Future<double?> getFaturamentoMensalGerente() async {
    try {
      final userId = authSettings.currentUser!.uid;

      // Obtém o idBarbearia do usuário
      String idBarbearia = "";
      try {
        final userDoc = await database.collection("usuarios").doc(userId).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          idBarbearia = data['idBarbearia'] ??
              ""; // Adicione o valor padrão se necessário
        } else {
          print("Usuário não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o id da barbearia: $e");
        return null;
      }

      DateTime momento = DateTime.now();
      String monthName = DateFormat('MMMM', 'pt_BR').format(momento);

      // Obtém o faturamento mensal
      double? faturamentoMensal;
      try {
        final faturamentoDoc = await database
            .collection("DadosConcretosBarbearias")
            .doc(idBarbearia)
            .collection("faturamentoMes")
            .doc("${monthName}.${momento.year}")
            .get();

        if (faturamentoDoc.exists) {
          Map<String, dynamic> data =
              faturamentoDoc.data() as Map<String, dynamic>;
          var valor = data["valor"];

          if (valor is int) {
            faturamentoMensal = valor.toDouble();
          } else if (valor is double) {
            faturamentoMensal = valor;
          } else {
            print("Tipo de valor inesperado: $valor");
            return null;
          }
        } else {
          print("Faturamento mensal não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o faturamento: $e");
        return null;
      }

      return faturamentoMensal;
    } catch (e) {
      print("Erro geral: $e");
      return null;
    }
  }

  //
  Future<double> getFaturamentoMensalGerenteMesSelecionado({
    required String mesSelecionado,
    required int anoDeBusca,
  }) async {
    final userId = authSettings.currentUser!.uid;
    String idBarbearia = "";

    try {
      // Pega o ID da barbearia
      var userDoc = await database.collection("usuarios").doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data();
        idBarbearia = data?['idBarbearia'] ?? "";
      } else {
        print("Usuário não encontrado");
        return 0.0; // Retorna 0.0 se o usuário não for encontrado
      }
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }

    try {
      // Pega o faturamento do mês selecionado
      var docSnapshot = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("faturamentoMes")
          .doc("${mesSelecionado.toLowerCase()}.${anoDeBusca}")
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null && data.containsKey("valor")) {
          // Converte o valor para double
          return (data["valor"] as num).toDouble();
        } else {
          print("Campo 'valor' não encontrado no documento");
          return 0.0; // Retorna 0.0 se o campo 'valor' não estiver presente
        }
      } else {
        print("Documento de faturamento não encontrado");
        return 0.0; // Retorna 0.0 se o documento não for encontrado
      }
    } catch (e) {
      print("Erro ao pegar o faturamento do mês selecionado: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }
  }

  //
  Future<double?> getFaturamentoMensalGerenteMesAnterior({
    required String mesAnterior,
    required int anoDeBusca,
  }) async {
    final userId = authSettings.currentUser!.uid;
    String idBarbearia = "";

    try {
      // Pegar o ID da barbearia
      await database.collection("usuarios").doc(userId).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarbearia = data['idBarbearia'];
        }
      });
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }

    try {
      double faturamentoMensal = 0.0;

      // Pegar o faturamento do mês anterior
      final docSnapshot = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("faturamentoMes")
          .doc("${mesAnterior.toLowerCase()}.${anoDeBusca}")
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey("valor")) {
          // Converte o valor para double
          faturamentoMensal = (data["valor"] as num).toDouble();
        }
      }
      return faturamentoMensal;
    } catch (e) {
      print("Erro ao pegar o mês anterior: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }
  }

  Future<double?> getComissaoTotalMensalGerente() async {
    final userId = await authSettings.currentUser!.uid;
    String idBarbearia = await "";
    try {
      await database.collection("usuarios").doc(userId).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          idBarbearia = data['idBarbearia'];
        }
      });
    } catch (e) {
      print("erro ao pegar o id da barbearia:$e");
    }
    DateTime momento = DateTime.now();
    String monthName = await DateFormat('MMMM', 'pt_BR').format(momento);

    double? comissaoTotalMes;
    await database
        .collection("DadosConcretosBarbearias")
        .doc(idBarbearia)
        .collection("comissaoTotalGerenteMes")
        .doc("${monthName}.${momento.year}")
        .get()
        .then(
      (event) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        comissaoTotalMes = data["valor"];
      },
    );
    return comissaoTotalMes;
  }

  Future<double?> calculoTicketMedio() async {
    try {
      final userId = authSettings.currentUser!.uid;

      // Obtém o idBarbearia do usuário
      final userDoc = await database.collection("usuarios").doc(userId).get();
      if (!userDoc.exists) {
        print("Usuário não encontrado");
        return null;
      }
      final idBarbearia =
          (userDoc.data() as Map<String, dynamic>)['idBarbearia'];

      if (idBarbearia == null) {
        print("idBarbearia não encontrado");
        return null;
      }

      // Obtém o mês atual
      final momento = DateTime.now();
      final monthName = DateFormat('MMMM', 'pt_BR').format(momento);

      // Obtém o faturamento mensal
      final faturamentoDoc = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("faturamentoMes")
          .doc("${monthName}.${momento.year}")
          .get();

      final faturamentoData = faturamentoDoc.exists
          ? faturamentoDoc.data() as Map<String, dynamic>
          : null;

      final faturamentoMensal = faturamentoData != null
          ? (faturamentoData["valor"] is int
              ? (faturamentoData["valor"] as int).toDouble()
              : faturamentoData["valor"] as double?)
          : null;

      if (faturamentoMensal == null) {
        print("Faturamento mensal não encontrado");
        return null;
      }

      // Conta o número de comandas
      final comandasSnapshot = await database
          .collection("comandas")
          .doc(idBarbearia)
          .collection("${monthName}.${DateTime.now().year}")
          .get();

      final tamanhoDaLista = comandasSnapshot.docs.length.toDouble();

      if (tamanhoDaLista == 0) {
        print("Não há comandas para calcular o ticket médio");
        return null;
      }

      // Calcula o ticket médio
      final ticketMedioCalculado = faturamentoMensal / tamanhoDaLista;
      return ticketMedioCalculado;
    } catch (e) {
      print("Erro ao calcular o ticket médio: $e");
      return null;
    }
  }

  Future<int?> getTotalClientesMes() async {
    try {
      final userId = authSettings.currentUser!.uid;

      // Obtém o idBarbearia do usuário
      final userDoc = await database.collection("usuarios").doc(userId).get();
      if (!userDoc.exists) {
        print("Usuário não encontrado");
        return null;
      }
      final idBarbearia =
          (userDoc.data() as Map<String, dynamic>)['idBarbearia'];

      if (idBarbearia == null) {
        print("idBarbearia não encontrado");
        return null;
      }

      // Obtém o mês atual
      final momento = DateTime.now();
      final monthName = DateFormat('MMMM', 'pt_BR').format(momento);
      // Conta o número de comandas
      final comandasSnapshot = await database
          .collection("comandas")
          .doc(idBarbearia)
          .collection("${monthName}.${momento.year}")
          .get();

      final tamanhoDaLista = comandasSnapshot.docs.length;

      if (tamanhoDaLista == 0) {
        print("Não há comandas para calcular o ticket médio");
        return null;
      }

      // Calcula o ticket médio

      return tamanhoDaLista;
    } catch (e) {
      print("Erro ao calcular o ticket médio: $e");
      return null;
    }
  }

  Future<double> getComissaoDoBarbeiroPeloMesInterno({
    required String mesSelecionado,
    required int anoDaBusca,
    required String barbeiroId,
  }) async {
    final userId = await authSettings.currentUser!.uid;
    String idBarbearia = "";
    try {
      final userDoc = await database.collection("usuarios").doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data();
        idBarbearia = data?['idBarbearia'] ?? "";
      } else {
        print("Erro: Documento do usuário não encontrado");
        return 0.0;
      }
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return 0.0;
    }

    try {
      final comissaoDoc = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("comissaoMensalBarbeiros")
          .doc(barbeiroId)
          .collection("${mesSelecionado}.${anoDaBusca}")
          .doc("dados")
          .get();

      if (comissaoDoc.exists) {
        Map<String, dynamic>? data = comissaoDoc.data();
        double comissaoTotalMes = data?["valor"]?.toDouble() ?? 0.0;
        return comissaoTotalMes;
      } else {
        print("Erro: Documento de comissão não encontrado");
        return 0.0;
      }
    } catch (e) {
      print("Erro ao pegar a comissão: $e");
      return 0.0;
    }
  }

  //coisas relacionadas aos indicadores da home - fim
  Future<double?> getValorDeRecorrentesEsteMes() async {
    String idBarbearia = "";

    try {
      // Obtém o ID da barbearia
      final userId = await authSettings.currentUser!.uid;
      var userDoc = await database.collection("usuarios").doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data();
        idBarbearia = data?['idBarbearia'] ?? "";
      } else {
        print("Usuário não encontrado");
        return null; // Retorna null se o usuário não for encontrado
      }
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return null; // Retorna null em caso de erro
    }

    try {
      // Pega o valor das despesas recorrentes do mês atual
      DateTime momento = DateTime.now();
      String monthName = DateFormat('MMMM', 'pt_BR').format(momento);

      var despesaDoc = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("valorTotalDespesasRecorrentes")
          .doc("valor")
          .get();

      if (despesaDoc.exists) {
        Map<String, dynamic>? data = despesaDoc.data();
        if (data != null) {
          return (data["valor"] as num?)?.toDouble(); // Converte para double
        } else {
          print("Dados não encontrados no documento de despesas recorrentes");
          return null;
        }
      } else {
        print("Documento de despesas recorrentes não encontrado");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar o valor das despesas recorrentes: $e");
      return null; // Retorna null em caso de erro
    }
  }

  //get da despesa do mes anterior
  Future<double> getDespesaMesAnterior({
    required String mesSelecionado,
    required int anoDeBusca,
  }) async {
    final userId = authSettings.currentUser!.uid;
    String idBarbearia = "";

    try {
      // Pegar o ID da barbearia
      await database.collection("usuarios").doc(userId).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarbearia = data['idBarbearia'];
        }
      });
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }

    try {
      double despesaTotalMesAnterior = 0.0;

      // Pegar o faturamento do mês selecionado
      final docSnapshot = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("historicoDespesas")
          .doc("${mesSelecionado.toLowerCase()}.${anoDeBusca}")
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey("valor")) {
          // Converte o valor para double
          despesaTotalMesAnterior = (data["valor"] as num).toDouble();
        }
      }
      return despesaTotalMesAnterior;
    } catch (e) {
      print("Erro ao pegar o mês selecionado: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }
  }

  Future<double> getDespesaMesSelecionado({
    required String mesSelecionado,
    required int anoDeBusca,
  }) async {
    print("#23 no getdespesas:${mesSelecionado}:${anoDeBusca}");
    final userId = authSettings.currentUser!.uid;
    String idBarbearia = "";

    try {
      // Pegar o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        idBarbearia = data['idBarbearia'] ?? "";
      }
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }

    try {
      double despesaTotalMesAnterior = 0.0;

      // Pegar o faturamento do mês selecionado
      final docSnapshot = await database
          .collection("Despesa")
          .doc(idBarbearia)
          .collection("historicoDespesas")
          .doc("${mesSelecionado.toLowerCase()}.${anoDeBusca}")
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey("valor")) {
          // Converte o valor para double de forma segura
          final valor = data["valor"];
          if (valor is num) {
            despesaTotalMesAnterior = valor.toDouble();
          } else if (valor is String) {
            despesaTotalMesAnterior = double.tryParse(valor) ?? 0.0;
          }
        }
      }
      return despesaTotalMesAnterior;
    } catch (e) {
      print("Erro ao pegar o mês selecionado: $e");
      return 0.0; // Retorna 0.0 em caso de erro
    }
  }

  Future<double?> getComissaoTotalMensalGerenteMes(
      {required String mes, required int ano}) async {
    final userId = await authSettings.currentUser!.uid;
    String idBarbearia = "";

    try {
      // Obtém o ID da barbearia
      var userDoc = await database.collection("usuarios").doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data();
        idBarbearia = data?['idBarbearia'] ?? "";
      } else {
        print("Usuário não encontrado");
        return null;
      }
    } catch (e) {
      print("Erro ao pegar o id da barbearia: $e");
      return null;
    }

    double? comissaoTotalMes;

    try {
      // Obtém a comissão total do mês
      var comissaoDoc = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("comissaoTotalGerenteMes")
          .doc("$mes.$ano")
          .get();

      if (comissaoDoc.exists) {
        Map<String, dynamic>? data = comissaoDoc.data();
        comissaoTotalMes = data?['valor']?.toDouble();
      } else {
        print("Documento de comissão não encontrado");
      }
    } catch (e) {
      print("Erro ao pegar a comissão do mês: $e");
    }

    return comissaoTotalMes;
  }

  Future<double?> calculoTicketMedioMesSelecionado({
    required String mes,
    required int ano,
  }) async {
    try {
      final userId = await authSettings.currentUser!.uid;
      String idBarbearia = "";

      try {
        // Obtém o ID da barbearia
        var userDoc = await database.collection("usuarios").doc(userId).get();
        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data();
          idBarbearia = data?['idBarbearia'] ?? "";
        } else {
          print("Usuário não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o id da barbearia: $e");
        return null;
      }
      print("iniciei o load do ticket");
      // Obtém o faturamento mensal
      final faturamentoDoc = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("faturamentoMes")
          .doc("${mes}.${ano}")
          .get();

      final faturamentoData = faturamentoDoc.exists
          ? faturamentoDoc.data() as Map<String, dynamic>
          : null;

      final faturamentoMensal = faturamentoData != null
          ? (faturamentoData["valor"] is int
              ? (faturamentoData["valor"] as int).toDouble()
              : faturamentoData["valor"] as double?)
          : null;

      if (faturamentoMensal == null) {
        print("Faturamento mensal não encontrado");
        return null;
      }

      // Conta o número de comandas
      final comandasSnapshot = await database
          .collection("comandas")
          .doc(idBarbearia)
          .collection("${mes}.${ano}")
          .get();

      final tamanhoDaLista = comandasSnapshot.docs.length.toDouble();

      if (tamanhoDaLista == 0) {
        print("Não há comandas para calcular o ticket médio");
        return null;
      }

      // Calcula o ticket médio
      final ticketMedioCalculado = faturamentoMensal / tamanhoDaLista;
      return ticketMedioCalculado;
    } catch (e) {
      print("Erro ao calcular o ticket médio: $e");
      return null;
    }
  }

  //
  Future<double?> calculoTicketMedioMesAnterior({
    required String mes,
    required int ano,
  }) async {
    try {
      final userId = await authSettings.currentUser!.uid;
      String idBarbearia = "";

      try {
        // Obtém o ID da barbearia
        var userDoc = await database.collection("usuarios").doc(userId).get();
        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data();
          idBarbearia = data?['idBarbearia'] ?? "";
        } else {
          print("Usuário não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o id da barbearia: $e");
        return null;
      }
      print("iniciei o load do ticket");
      // Obtém o faturamento mensal
      final faturamentoDoc = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("faturamentoMes")
          .doc("${mes}.${ano}")
          .get();

      final faturamentoData = faturamentoDoc.exists
          ? faturamentoDoc.data() as Map<String, dynamic>
          : null;

      final faturamentoMensal = faturamentoData != null
          ? (faturamentoData["valor"] is int
              ? (faturamentoData["valor"] as int).toDouble()
              : faturamentoData["valor"] as double?)
          : null;

      if (faturamentoMensal == null) {
        print("Faturamento mensal não encontrado");
        return null;
      }

      // Conta o número de comandas
      final comandasSnapshot = await database
          .collection("comandas")
          .doc(idBarbearia)
          .collection("${mes}.${ano}")
          .get();

      final tamanhoDaLista = comandasSnapshot.docs.length.toDouble();

      if (tamanhoDaLista == 0) {
        print("Não há comandas para calcular o ticket médio");
        return null;
      }

      // Calcula o ticket médio
      final ticketMedioCalculado = faturamentoMensal / tamanhoDaLista;
      return ticketMedioCalculado;
    } catch (e) {
      print("Erro ao calcular o ticket médio: $e");
      return null;
    }
  }

  Future<int?> getTotalClientesMesSelecionado(
      {required String mesSelecionado, required int anoSelecionado}) async {
    try {
      final userId = authSettings.currentUser!.uid;

      // Obtém o idBarbearia do usuário
      final userDoc = await database.collection("usuarios").doc(userId).get();
      if (!userDoc.exists) {
        print("Usuário não encontrado");
        return null;
      }
      final idBarbearia =
          (userDoc.data() as Map<String, dynamic>)['idBarbearia'];

      if (idBarbearia == null) {
        print("idBarbearia não encontrado");
        return null;
      }

      // Obtém o mês atual

      // Conta o número de comandas
      final comandasSnapshot = await database
          .collection("comandas")
          .doc(idBarbearia)
          .collection("${mesSelecionado.toLowerCase()}.${anoSelecionado}")
          .get();

      final tamanhoDaLista = comandasSnapshot.docs.length;

      if (tamanhoDaLista == 0) {
        print("Não há comandas para calcular o ticket médio");
        return null;
      }

      // Calcula o ticket médio

      return tamanhoDaLista;
    } catch (e) {
      print("Erro ao calcular o ticket médio: $e");
      return null;
    }
  }

  Future<int?> getTotaldeClientesTotalComandas() async {
    try {
      final userId = authSettings.currentUser!.uid;

      // Obtém o idBarbearia do usuário
      final userDoc = await database.collection("usuarios").doc(userId).get();
      if (!userDoc.exists) {
        print("Usuário não encontrado");
        return null;
      }
      final idBarbearia =
          (userDoc.data() as Map<String, dynamic>)['idBarbearia'];

      if (idBarbearia == null) {
        print("idBarbearia não encontrado");
        return null;
      }

      // Obtém o mês atual

      // Conta o número de comandas
      final comandasSnapshot = await database
          .collection("TodasAscomandas")
          .doc(idBarbearia)
          .collection("lista")
          .get();

      final tamanhoDaLista = comandasSnapshot.docs.length;

      if (tamanhoDaLista == 0) {
        print("Não há comandas para calcular o ticket médio");
        return null;
      }

      // Calcula o ticket médio

      return tamanhoDaLista;
    } catch (e) {
      print("Erro ao calcular o ticket médio: $e");
      return null;
    }
  }

  List<Comanda> _comandaList = [];
  List<Comanda> get comandaList => [..._comandaList];

  final StreamController<List<Comanda>> _comandaListStream =
      StreamController<List<Comanda>>.broadcast();

  Stream<List<Comanda>> get comandaListStream => _comandaListStream.stream;

  Future<void> loadComandasMesSelecionado({
    required String mesSelecionado,
    required int year,
  }) async {
    print("tela do manager, 7 dias corte funcao executada");

    try {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userIdbarbearia;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userIdbarbearia = data['idBarbearia'];
        } else {}
        return userIdbarbearia;
      });

      QuerySnapshot querySnapshot = await database
          .collection("comandas")
          .doc(userIdbarbearia)
          .collection("${mesSelecionado.toLowerCase()}.${year}")
          .get();

      _comandaList = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        return Comanda(
            dataFinalizacao: (data?["dataFinalizacao"] is Timestamp)
                ? (data?["dataFinalizacao"] as Timestamp?)?.toDate() ??
                    DateTime.now()
                : DateTime.tryParse(data?["dataFinalizacao"] ?? "") ??
                    DateTime.now(),
            id: data?[""] ?? "",
            idBarbearia: data?["idBarbearia"] ?? "",
            idBarbeiroQueCriou: data?["idBarbeiroQueCriou"] ?? "",
            nomeCliente: data?["nomeCliente"] ?? "Sem nome...",
            produtosVendidos: (data?["produtosVendidos"] as List<dynamic>?)
                    ?.map((item) {
                  // Converta o item para o tipo de dado esperado (ex: Produto)
                  return Produtosavenda.fromMap(item as Map<String, dynamic>);
                }).toList() ??
                [],
            servicosFeitos:
                (data?["servicosFeitos"] as List<dynamic>?)?.map((item) {
                      // Converta o item para o tipo de dado esperado (ex: Servico)
                      return Servico.fromMap(item as Map<String, dynamic>);
                    }).toList() ??
                    [],
            valorTotalComanda: data?["valorTotalComanda"] ?? 0.0);
      }).toList();
      _comandaListStream.add(_comandaList);
    } catch (e) {
      print("ao carregar a lista do manager dia, deu isto: ${e}");
    }
    print("o tamanho da lista é manager ${_comandaList.length}");
    notifyListeners();
  }

  Future<String?> getCEPbarbearia() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarberaria = data['idBarbearia'];
        }
      });

      print("toa qui");

      if (idBarberaria == null) {
        return null; // Se o idBarbearia não foi encontrado, retorne null
      }

      String? cep;

      // Pega a descrição da barbearia
      await database
          .collection("Barbearias")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          print("encontamos algo");
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          cep = data['cep'];
          print("encontamos algo: $cep");
        } else {
          print("isso nao existe");
        }
      });

      return cep;
    } catch (e) {
      print("ao pegar a descricaoDaBarbeariaDeuIsto: $e");
      return null; // Retorna null em caso de erro
    }
  }

  Future<String?> getCidadebarbearia() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarberaria = data['idBarbearia'];
        }
      });

      print("toa qui");

      if (idBarberaria == null) {
        return null; // Se o idBarbearia não foi encontrado, retorne null
      }

      String? cidade;

      // Pega a descrição da barbearia
      await database
          .collection("Barbearias")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          print("encontamos algo");
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          cidade = data['cidade'];
          print("encontamos algo: $cidade");
        } else {
          print("isso nao existe");
        }
      });

      return cidade;
    } catch (e) {
      print("ao pegar a cidade: $e");
      return null; // Retorna null em caso de erro
    }
  }

  Future<String?> getEnderecobarbearia() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarberaria = data['idBarbearia'];
        }
      });

      print("toa qui");

      if (idBarberaria == null) {
        return null; // Se o idBarbearia não foi encontrado, retorne null
      }

      String? NomeRuaBairroeNumbero;

      // Pega a descrição da barbearia
      await database
          .collection("Barbearias")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          print("encontamos algo");
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          NomeRuaBairroeNumbero = data['NomeRuaBairroeNumbero'];
          print("encontamos algo: $NomeRuaBairroeNumbero");
        } else {
          print("isso nao existe");
        }
      });

      return NomeRuaBairroeNumbero;
    } catch (e) {
      print("ao pegar a NomeRuaBairroeNumbero: $e");
      return null; // Retorna null em caso de erro
    }
  }

  final StreamController<List<Horarios>> _horariosSemanaStream =
      StreamController<List<Horarios>>.broadcast();

  Stream<List<Horarios>> get getHorariosSemana => _horariosSemanaStream.stream;
  List<Horarios> _horariosSemana = [];

  List<Horarios> get horariosSegunda => _horariosSemana;

  Future<void> loadHorariosSemana() async {
    print("entrei na funcao");
    try {
      print("acessamos aqui no load segunda");
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      print("toa qui");

      if (idBarberaria == null) {
        print('ID da barbearia não encontrado!');
        return; // Saia do método se o ID não for encontrado
      }

      // Obtendo a referência ao Firestore
      final firestore = FirebaseFirestore.instance;

      // Acessando o documento desejado
      final docRef = firestore.collection('Barbearias').doc(idBarberaria);

      // Obtendo o documento
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Obtendo os dados do documento
        final data = docSnapshot.data() as Map<String, dynamic>;

        // Obtendo o array de horariossegunda
        final horariosList = data['horarioSemana'] as List<dynamic>;

        // Convertendo o array para uma lista de Horarios
        _horariosSemana = horariosList.map((item) {
          return Horarios.fromMap(item as Map<String, dynamic>);
        }).toList();

// Atualizando o stream com os dados carregados
        _horariosSemanaStream.add(_horariosSemana);
      } else {
        // Documento não encontrado
        print('Documento não encontrado!');
      }
    } catch (e) {
      // Tratamento de erros
      print('Erro ao carregar horários: $e');
    }
  }

  //sabado
  final StreamController<List<Horarios>> _horariosSabadoStream =
      StreamController<List<Horarios>>.broadcast();

  Stream<List<Horarios>> get getHorariosSabado => _horariosSabadoStream.stream;
  List<Horarios> _horariosSabado = [];

  List<Horarios> get horariosSabado => _horariosSabado;

  Future<void> loadHorariosSabado() async {
    print("entrei na funcao de sabado");
    try {
      print("acessamos aqui no load sabado");
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      print("toa qui sabado");

      if (idBarberaria == null) {
        print('ID da barbearia não encontrado! sabado');
        return; // Saia do método se o ID não for encontrado
      }

      // Obtendo a referência ao Firestore
      final firestore = FirebaseFirestore.instance;

      // Acessando o documento desejado
      final docRef = firestore.collection('Barbearias').doc(idBarberaria);

      // Obtendo o documento
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        print("sabado tem dados");
        // Obtendo os dados do documento
        final data = await docSnapshot.data() as Map<String, dynamic>;

        // Obtendo o array de horariossegunda
        final horariosList = await data['horarioSabado'] as List<dynamic>;

        // Convertendo o array para uma lista de Horarios
        _horariosSabado = await horariosList.map((item) {
          final horario = Horarios.fromMap(item as Map<String, dynamic>);
          // Printando os dados convertidos
          print('Horário : ${horario.horario}, isActive: ${horario.isActive}');
          return horario;
        }).toList();
// Atualizando o stream com os dados carregados
        _horariosSabadoStream.add(_horariosSabado);
      } else {
        // Documento não encontrado
        print('Documento não encontrado sabado! sabado');
      }
    } catch (e) {
      // Tratamento de erros
      print('Erro ao carregar horários sabado:  $e');
    }
  }

  //domingo
  final StreamController<List<Horarios>> _horariosDomingoStream =
      StreamController<List<Horarios>>.broadcast();

  Stream<List<Horarios>> get getHorariosDomingo =>
      _horariosDomingoStream.stream;
  List<Horarios> _horariosDomingo = [];

  List<Horarios> get horariosDomingo => _horariosDomingo;

  Future<void> loadHorariosDomingo() async {
    print("entrei na funcao de sabado");
    try {
      print("acessamos aqui no load sabado");
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      print("toa qui sabado");

      if (idBarberaria == null) {
        print('ID da barbearia não encontrado! sabado');
        return; // Saia do método se o ID não for encontrado
      }

      // Obtendo a referência ao Firestore
      final firestore = FirebaseFirestore.instance;

      // Acessando o documento desejado
      final docRef = firestore.collection('Barbearias').doc(idBarberaria);

      // Obtendo o documento
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        print("sabado tem dados");
        // Obtendo os dados do documento
        final data = await docSnapshot.data() as Map<String, dynamic>;

        // Obtendo o array de horariossegunda
        final horariosList = await data['horarioDomingo'] as List<dynamic>;

        // Convertendo o array para uma lista de Horarios
        _horariosDomingo = await horariosList.map((item) {
          final horario = Horarios.fromMap(item as Map<String, dynamic>);
          // Printando os dados convertidos
          print('Horário : ${horario.horario}, isActive: ${horario.isActive}');
          return horario;
        }).toList();
// Atualizando o stream com os dados carregados
        _horariosDomingoStream.add(_horariosDomingo);
      } else {
        // Documento não encontrado
        print('Documento não encontrado sabado! sabado');
      }
    } catch (e) {
      // Tratamento de erros
      print('Erro ao carregar horários sabado:  $e');
    }
  }

  //
  Future<int?> getAvaliacaoGeral() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      print("toa qui sabado");

      int? avaliacaoGeral;

      await database
          .collection("Barbearias")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          avaliacaoGeral = data['avaliacaoGeral'].toInt();
        } else {}
        return int;
      });
      print("avaliacao final ficou:$avaliacaoGeral");
      return avaliacaoGeral;
    } catch (e) {
      print("ao pegar a avaliacao final deu $e");
    }
  }

  List<String> _bannerList = [];
  List<String> get bannerList =>
      [..._bannerList]; // Retorna uma cópia imutável da lista

  final StreamController<List<String>> _bannersController =
      StreamController<List<String>>.broadcast();
  Stream<List<String>> get bannersStream => _bannersController.stream;

  Future<void> loadBanners() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarberaria = data['idBarbearia'];
        }
      });

      if (idBarberaria == null) {
        _bannerList = []; // Limpa a lista se não encontrar a barbearia
        _bannersController.sink.add(_bannerList); // Atualiza o stream
        return;
      }

      List<String>? wallpaperPagina;

      // Pega a descrição da barbearia
      await database
          .collection("Barbearias")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          wallpaperPagina = List<String>.from(data['wallpaperPagina'] ?? []);
        }
      });

      if (wallpaperPagina != null) {
        _bannerList = wallpaperPagina!; // Atualiza a lista local
        _bannersController.sink
            .add(_bannerList); // Emite a lista atualizada no stream
      } else {
        _bannerList = []; // Se não houver wallpapers, zera a lista
        _bannersController.sink
            .add(_bannerList); // Emite a lista vazia no stream
      }
    } catch (e) {
      print("Erro ao carregar os banners: $e");
      _bannerList = []; // Limpa a lista em caso de erro
      _bannersController.sink
          .add(_bannerList); // Atualiza o stream com a lista vazia
    }
  }

  Future<int?> getPontosMinimosClientes() async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;
          idBarberaria = data['idBarbearia'];
        }
      });

      int? minimoPontos;

      await database
          .collection("PontuacoesConfiguradas")
          .doc(idBarberaria)
          .get()
          .then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          minimoPontos = data['Pontos'] ?? 0;
        } else {}
        return minimoPontos;
      });
      return minimoPontos;
    } catch (e) {}
  }

  Future<double?> getComissaoDoBarbeiroVisaoFuncionario() async {
    try {
      final userId = authSettings.currentUser!.uid;

      // Obtém o idBarbearia do usuário
      String idBarbearia = "";
      String idBarbeiroGetForDbFinal = "";
      try {
        final userDoc = await database.collection("usuarios").doc(userId).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          idBarbearia = data['idBarbearia'] ??
              ""; // Adicione o valor padrão se necessário
        } else {
          print("Usuário não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o id da barbearia: $e");
        return null;
      }
      try {
        final userDoc = await database.collection("usuarios").doc(userId).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          idBarbeiroGetForDbFinal = data['idBarbeiroGetForDb'] ??
              ""; // Adicione o valor padrão se necessário
        } else {
          print("Usuário não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o id da barbearia: $e");
        return null;
      }

      DateTime momento = DateTime.now();
      String monthName = DateFormat('MMMM', 'pt_BR').format(momento);

      // Obtém o faturamento mensal
      double? comissaoMesAtual;
      try {
        final faturamentoDoc = await database
            .collection("DadosConcretosBarbearias")
            .doc(idBarbearia)
            .collection("comissaoMensalBarbeiros")
            .doc(idBarbeiroGetForDbFinal)
            .collection("${monthName}.${momento.year}")
            .doc("dados")
            .get();
        if (faturamentoDoc.exists) {
          Map<String, dynamic> data =
              faturamentoDoc.data() as Map<String, dynamic>;
          var valor = data["valor"];

          if (valor is int) {
            comissaoMesAtual = valor.toDouble();
          } else if (valor is double) {
            comissaoMesAtual = valor;
          } else {
            print("Tipo de valor inesperado: $valor");
            return null;
          }
        } else {
          print("Faturamento mensal não encontrado");
          return null;
        }
      } catch (e) {
        print("Erro ao pegar o faturamento: $e");
        return null;
      }

      return comissaoMesAtual;
    } catch (e) {
      print("Erro geral: $e");
      return null;
    }
  }

  Future<int?> getQuantiaClientesMesFuncionario() async {
    if (authSettings.currentUser != null) {
      final String uidUser = authSettings.currentUser!.uid;
      int? totalClients;
      double? meuIdDeBarbeiro;
      String? idBarbearia;

      // Obter informações do barbeiro e da barbearia em uma única chamada
      final userSnapshot =
          await database.collection("usuarios").doc(uidUser).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;

        // Converter para double, se possível
        meuIdDeBarbeiro =
            double.tryParse(data['idBarbeiroGetForDb'].toString());
        idBarbearia = data['idBarbearia'];
      }

      // Verificar se os valores foram obtidos corretamente
      if (meuIdDeBarbeiro == null || idBarbearia == null) {
        print("Erro ao obter idBarbearia ou meuIdDeBarbeiro");
        return null;
      }

      // Definir o caminho correto e formatar o nome do mês
      DateTime momento = DateTime.now();
      String monthName =
          DateFormat('MMMM', 'pt_BR').format(momento).toLowerCase();
      String year = momento.year.toString();

      print(
          "Lendo isso: DadosConcretosBarbearias/$idBarbearia/QuantiaBarbeiroCorou/$monthName.$year/${meuIdDeBarbeiro.toString()}/valor");

      // Acessar o documento no Firestore corretamente
      final quantiaSnapshot = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("QuantiaBarbeiroCorou")
          .doc("$monthName.$year")
          .collection(meuIdDeBarbeiro.toString())
          .doc("valor")
          .get();

      // Verificar se o documento existe e capturar o valor
      if (quantiaSnapshot.exists) {
        Map<String, dynamic> data =
            quantiaSnapshot.data() as Map<String, dynamic>;
        totalClients = data['valor'] as int?;
      }

      return totalClients;
    }

    return null;
  }
}
