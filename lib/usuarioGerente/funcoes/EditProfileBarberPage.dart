import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
