import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jimy/usuarioGerente/classes/pagamentos.dart';

class Editprofilebarberpage with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;

  Future<void> addPayments({required List<Pagamentos> pagamentos}) async {
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
      final firstAjust =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "FormasPagamento": [],
      });
      final List<Map<String, dynamic>> pagamentosMap =
          pagamentos.map((pagamento) => pagamento.toMap()).toList();

      final pubPayents =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "FormasPagamento": FieldValue.arrayUnion(pagamentosMap),
      });
      notifyListeners();
    } catch (e) {
      print("ao atualizar formas de pagamento deu isto:$e");
      throw e;
    }
  }

  //
  Future<List<Map<String, dynamic>>> getFormasPagamento() async {
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

      // Pega o documento da barbearia
      DocumentSnapshot documentSnapshot =
          await database.collection("Barbearias").doc(idBarberaria).get();

      // Verifica se o campo "FormasPagamento" existe e retorna a lista
      if (documentSnapshot.exists) {
        List<dynamic> formasPagamento =
            documentSnapshot.get('FormasPagamento') as List<dynamic>;

        // Converte cada item da lista em Map<String, dynamic>
        List<Map<String, dynamic>> pagamentos = formasPagamento
            .map((item) => item as Map<String, dynamic>)
            .toList();

        return pagamentos;
      } else {
        print("Documento da barbearia não encontrado.");
        return [];
      }
    } catch (e) {
      print("Erro ao buscar formas de pagamento: $e");
      throw e;
    }
  }

  Future<void> attNomeBarbearia({required String NovoNome}) async {
    print("here");
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
      print("entrei aqui");
      final pubnewName =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "nomeBarbearia": NovoNome,
      });
      final attNomeProfile =
          await database.collection("usuarios").doc(uidUser).update({
        "nomeBarbearia": NovoNome,
      });
    } catch (e) {
      print("erro ao atualizar o nome:$e");
      throw e;
    }
  }

  Future<void> attDescricaoBarbearia({required String novaDescricao}) async {
    print("here");
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
      print("entrei aqui");
      final pubnewName =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "descricaoBarbearia": novaDescricao,
      });
    } catch (e) {
      print("erro ao atualizar o nome:$e");
      throw e;
    }
  }

  Future<void> attBairroRuaENumeroBarbearia({required String endereco}) async {
    print("here");
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
      print("entrei aqui");
      final pubnewName =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "NomeRuaBairroeNumbero": endereco,
      });
    } catch (e) {
      print("erro ao atualizar o nome:$e");
      throw e;
    }
  }

  Future<void> attCEP({required String CEP}) async {
    print("here");
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
      print("entrei aqui");
      final pubnewName =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "cep": CEP,
      });
    } catch (e) {
      print("erro ao atualizar o nome:$e");
      throw e;
    }
  }

  Future<void> attCidade({required String Cidade}) async {
    print("here");
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
      print("entrei aqui");
      final pubnewName =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "cidade": Cidade,
      });
    } catch (e) {
      print("erro ao atualizar o nome:$e");
      throw e;
    }
  }

  Future<void> sendNewBanner(
      {required File file, required String idForImage}) async {
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
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("bannersBarbearias/${idForImage}");
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => null);
      String imageBannerAdd = await ref.getDownloadURL();

      //agora atualizando
      final pubNewBannner =
          await database.collection("Barbearias").doc(idBarberaria).update({
        "wallpaperPagina": FieldValue.arrayUnion([imageBannerAdd]),
      });
    } catch (e) {
      print("Ao enviar a imagem, na funcao do DB ocorreu isso:$e");
    }
  }

  Future<void> removeBanner({required String url}) async {
    try {
      final String uidUser = authSettings.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      } else {
        throw Exception("Usuário não encontrado.");
      }

      if (idBarberaria == null) {
        throw Exception("ID da barbearia não encontrado.");
      }

      // Remove a URL do array no Firestore
      await database.collection("Barbearias").doc(idBarberaria).update({
        "wallpaperPagina": FieldValue.arrayRemove([url]),
      });
    } catch (e) {
      print("Ao excluir o banner, ocorreu isto: $e");
      throw e;
    }
  }
}
