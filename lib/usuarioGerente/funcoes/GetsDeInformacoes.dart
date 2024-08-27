import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';

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

  //GET DOS CORTES DA BARBEARIA PARA EXIBIR NA TELA
  //#1 GET dos Horários
  List<Horarios> _listaHorairos = [];
  List<Horarios> get listaHorairos => [..._listaHorairos];
  Future<void> loadHorariosSemana({
    required String diaSemana,
  }) async {
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
}
