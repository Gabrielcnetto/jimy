import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CriarcontaelogarProvider with ChangeNotifier {
  //bibliotecas - packages
  final database = FirebaseFirestore.instance;
  final authConfigs = FirebaseAuth.instance;
  final Storage = FirebaseStorage.instance;

  Future<void> criarContaClienteNormal({
    required String cidade,
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await authConfigs.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userIdCreate = await authConfigs.currentUser!.uid;
      final pubNewCliente =
          await database.collection("usuarios").doc(userIdCreate).set({
        //identificador pra fazer ele um cliente
        "clienteNormal": true,
        "donoBarbearia": false,
        "funcionarioBarbearia": false,
        "distribuidor": false,

        //atributos para usuario utilizar e visualizar e localizar o cliente
        'PhoneNumber': "",
        'userIdDatabase': userIdCreate,
        "urlPerfilImage":
            "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92",
        "Dimypoints": 0,
        "userName": userName,
        "email": email,
        "senha": password,
        "cidade": cidade,
        "cep": "",

        //pagamentos
        'saldoConta': 0.0,
      });
      notifyListeners();
    } catch (e) {
      print("erro:$e");
      throw e;
    }
  }

  Future<void> criarContaClienteDistribuidor({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await authConfigs.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userIdCreate = await authConfigs.currentUser!.uid;
      final pubNewCliente =
          await database.collection("usuarios").doc(userIdCreate).set({
        "clienteNormal": false,
        "donoBarbearia": false,
        "funcionarioBarbearia": false,
        "distribuidor": true,

        //atributos para usuario utilizar e visualizar e localizar o distribuidor
        'PhoneNumber': "",
        'userIdDatabase': userIdCreate,
        "urlPerfilImage":
            "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92",

        "userName": userName,
        "email": email,
        "senha": password,

        //identificar e encontrar a loja do distribuidor

        "nomeDaLoja": "",
        "idDaLoja": "",
        "imagemPerfilLoja:":
            "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92",

        //Vendas
        'totalVendas': 0.0,
      });
      notifyListeners();
    } catch (e) {
      print("erro:$e");
      throw e;
    }
  }

  Future<void> criarContaClienteGerenteBarbearia({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await authConfigs.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userIdCreate = await authConfigs.currentUser!.uid;
      final pubNewCliente =
          await database.collection("usuarios").doc(userIdCreate).set({
        "clienteNormal": false,
        "donoBarbearia": true,
        "funcionarioBarbearia": false,
        "distribuidor": false,

        //atributos para usuario utilizar e visualizar e localizar o dono
        'PhoneNumber': "",
        'userIdDatabase': userIdCreate,
        "urlPerfilImage":
            "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92",

        "userName": userName,
        "email": email,
        "senha": password,

        //identificar e encontrar a barbearia

        "nomeBarbearia": "",
        "idBarbearia": "",
        "imagemPerfilBarbearia:":
            "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92",

        //Vendas
        'totalVendas': 0.0,
      });
      notifyListeners();
    } catch (e) {
      print("erro:$e");
      throw e;
    }
  }

  //Fazendo o get de tipo de usuario
  Future<bool?> getUserIsManager() async {
    if (authConfigs.currentUser == null) {
      return null; // Retorna imediatamente se o usuário não estiver autenticado
    }

    final String uidUser = authConfigs.currentUser!.uid;
    bool? isManager;

    await database.collection("usuarios").doc(uidUser).get().then((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.data(); // Use Map<String, dynamic>?

        if (data != null && data.containsKey('donoBarbearia')) {
          isManager = data['donoBarbearia'] ?? false;
        }
      }
    });

    return isManager; // Retorna o valor de isManager, que pode ser null
  }

  //
  Future<bool?> getUserIsUsuarioNormal() async {
    if (authConfigs.currentUser == null) {
      return null; // Retorna imediatamente se o usuário não estiver autenticado
    }

    final String uidUser = authConfigs.currentUser!.uid;
    bool? isManager;

    await database.collection("usuarios").doc(uidUser).get().then((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.data(); // Use Map<String, dynamic>?

        if (data != null && data.containsKey('clienteNormal')) {
          isManager = data['clienteNormal'] ?? false;
        }
      }
    });

    return isManager; // Retorna o valor de isManager, que pode ser null
  }

  //
  Future<bool?> getUserIsUsuarioDistribuidor() async {
    if (authConfigs.currentUser == null) {
      return null; // Retorna imediatamente se o usuário não estiver autenticado
    }

    final String uidUser = authConfigs.currentUser!.uid;
    bool? isManager;

    await database.collection("usuarios").doc(uidUser).get().then((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.data(); // Use Map<String, dynamic>?

        if (data != null && data.containsKey('distribuidor')) {
          isManager = data['distribuidor'] ?? false;
        }
      }
    });

    return isManager; // Retorna o valor de isManager, que pode ser null
  }

  //EFETUAR O LOGIN NO SISTEMA
  Future<void> userLogin(
      {required String email, required String password}) async {
        print("email: $email");
        print("senha: $password");
    try {
      final login = await authConfigs.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
      if (e.code == 'invalid-email') {
        print('O e-mail fornecido está incorreto.');
      } else if (e.code == 'user-not-found') {
        print('Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        print('Senha incorreta.');
      } else {
        print('Erro desconhecido: ${e.message}');
      }
    } else {
      print('Erro não relacionado ao Firebase: ${e.toString()}');
    }
      print("ao logar deu erro: $e");
      throw e;

    }
  }

  Future<void>deslogar()async{
    authConfigs.signOut();
  }
}
