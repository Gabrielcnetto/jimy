import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';

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

    double? faturamentoMensal;
    await database
        .collection("DadosConcretosBarbearias")
        .doc(idBarbearia)
        .collection("faturamentoMes")
        .doc(monthName)
        .get()
        .then(
      (event) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        faturamentoMensal = data["valor"];
      },
    );
    return faturamentoMensal;
  }

  //
  Future<double> getFaturamentoMensalGerenteMesSelecionado({
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
      double faturamentoMensal = 0.0;

      // Pegar o faturamento do mês selecionado
      final docSnapshot = await database
          .collection("DadosConcretosBarbearias")
          .doc(idBarbearia)
          .collection("faturamentoMes")
          .doc("${mesSelecionado.toLowerCase()}.${anoDeBusca}")
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
      print("Erro ao pegar o mês selecionado: $e");
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

      final faturamentoMensal = faturamentoDoc.exists
          ? (faturamentoDoc.data() as Map<String, dynamic>)["valor"] as double?
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

    double? valorEmDespesaRecorrenteEsteMes;
    await database
        .collection("Despesa")
        .doc(idBarbearia)
        .collection("valorTotalDespesasRecorrentes")
        .doc("valor")
        .get()
        .then(
      (event) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        valorEmDespesaRecorrenteEsteMes = data["valor"];
      },
    );
    return valorEmDespesaRecorrenteEsteMes;
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

}
