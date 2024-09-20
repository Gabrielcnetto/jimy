import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:friotrim/usuarioGerente/classes/produto.dart';

class CriarEEnviarprodutos with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authConfigs = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  Future<void> setNewProduct({
    required File urlImage,
    required Produtosavenda produtoVenda,
    required String idBarbearia,
  }) async {
    print("entrei na funcao de enviar o produto ao db");
    //INICIO => Enviando a foto
    try {
      print("entrei no try");
      Reference ref = storage
          .ref()
          .child("ProdutosBarbeariasImagens/${produtoVenda.id.toLowerCase()}");
      UploadTask uploadTask = ref.putFile(urlImage);
      await uploadTask.whenComplete(() => null);
      String imageProfileImage = await ref.getDownloadURL();
      print("postei a foto:${imageProfileImage}");
      //FIM => enviando a foto

      //Enviando o Produto ao DATABASE
      await database
          .collection("Produtos")
          .doc(idBarbearia)
          .collection("lista")
          .doc(produtoVenda.id)
          .set({
        "categorias": produtoVenda.categorias,
        "ativoParaExibir": true,
        'descricao': produtoVenda.descricao,
        'estoque': produtoVenda.estoque,
        'id': produtoVenda.id,
        'nome': produtoVenda.nome,
        'preco': produtoVenda.preco,
        'quantiavendida': 0,
        'urlImage': imageProfileImage,
        'precoAntigo': 0,
      });
    } catch (e) {
      print("ocorreu um erro: $e");
      throw e;
    }
    notifyListeners();
  }

  //load
  final StreamController<List<Produtosavenda>> _produtosAvendaStream =
      StreamController<List<Produtosavenda>>.broadcast();

  Stream<List<Produtosavenda>> get ProdutosAvendaStream =>
      _produtosAvendaStream.stream;
  List<Produtosavenda> _produtosAvenda = [];
  List<Produtosavenda> get produtosAvenda => [..._produtosAvenda];
  Future<void> LoadProductsBarbearia() async {
    print("entrei no load");
    try {
      String? idBarbearia;
      try {
        final String uidUser = await authConfigs.currentUser!.uid;

        await database.collection("usuarios").doc(uidUser).get().then((event) {
          if (event.exists) {
            Map<String, dynamic> data = event.data() as Map<String, dynamic>;

            idBarbearia = data['idBarbearia'];
          }
          return idBarbearia;
        });
      } catch (e) {
        print("ao pegar o id da barbearia ocorreu isto:$e");
      }
      print("entrei no try");
      QuerySnapshot querySnapshot = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .get();
      _produtosAvenda = querySnapshot.docs.map((doc) {
        print("entrei no map do doc");
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        print("${data!.isEmpty ? "empy" : "tem item"}");
        List<String> categorias = List<String>.from(data?['categorias'] ?? []);

        // Acessando os atributos diretamente usando []
        return Produtosavenda(
          categorias: categorias,
          ativoParaExibir: data?["ativoParaExibir"] ?? true,
          descricao: data?["descricao"] ?? "",
          estoque: data?["estoque"] ?? 0,
          id: data?["id"] ?? "",
          nome: data?["nome"] ?? "",
          preco: (data?["preco"] as num?)?.toDouble() ?? 0.0,
          quantiavendida: data?["quantiavendida"] ?? 0,
          urlImage: data?["urlImage"] ?? "",
          precoAntigo: (data?["precoAntigo"] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
      _produtosAvendaStream.add(_produtosAvenda);
      print("o lengh da lista de produto é ${_produtosAvenda.length}");
      // Ordenar os dados pela data
      _produtosAvenda.sort((a, b) {
        return a.estoque.compareTo(b.estoque);
      });
    } catch (e) {
      print("houve um erro:$e");
    }
  }

  //
  Future<void> ToggleProdutoDoCatalogoDaBarbearia({
    required String productId,
    required bool newBool,
    required String idBarbearia,
  }) async {
    try {
      final attdb2 = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .doc(productId)
          .update({
        "ativoParaExibir": newBool,
      });
      ;

      LoadProductsBarbearia();
      print("finalizado");
    } catch (e) {
      print("$e");
      throw e;
    }
  }

  Future<void> uploadDeImagem({
    required File urlImage,
    required String productId,
    required String idBarbearia,
  }) async {
    Reference ref = storage
        .ref()
        .child("ProdutosBarbeiroImagens/${productId.toLowerCase()}");
    UploadTask uploadTask = ref.putFile(urlImage);
    await uploadTask.whenComplete(() => null);
    String imageProfileImage = await ref.getDownloadURL();

    final attdb2 = await database
        .collection('Produtos')
        .doc(idBarbearia)
        .collection("lista")
        .doc(productId)
        .update({
      "urlImage": imageProfileImage,
    });
  }

  Future<void> setNewTitle({
    required String productId,
    required String newtitle,
    required String idBarbearia,
  }) async {
    try {
      final attdb2 = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .doc(productId)
          .update({
        "nome": newtitle,
      });
      LoadProductsBarbearia();
      print("finalizado");
    } catch (e) {
      print("$e");
      throw e;
    }
  }

  Future<void> setNewPrice({
    required String productId,
    required double newPrice,
    required String idBarbearia,
  }) async {
    try {
      final attdb2 = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .doc(productId)
          .update({
        "preco": newPrice,
      });
      LoadProductsBarbearia();
      print("finalizado");
    } catch (e) {
      print("$e");
      throw e;
    }
  }

  Future<void> setNewDescription({
    required String productId,
    required String newDescription,
    required String idBarbearia,
  }) async {
    try {
      final attdb2 = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .doc(productId)
          .update({
        "descricao": newDescription,
      });
      LoadProductsBarbearia();
      print("finalizado");
    } catch (e) {
      print("$e");
      throw e;
    }
  }

  Future<void> setNewEstoque({
    required String productId,
    required int newEstoque,
    required String idBarbearia,
  }) async {
    try {
      final attdb2 = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .doc(productId)
          .update({
        "estoque": newEstoque,
      });
      LoadProductsBarbearia();
      print("finalizado");
    } catch (e) {
      print("$e");
      throw e;
    }
  }

  Future<void> deleteProduto({
    required String productId,
    required String idBarbearia,
  }) async {
    try {
      final attdb2 = await database
          .collection('Produtos')
          .doc(idBarbearia)
          .collection("lista")
          .doc(productId)
          .delete();
    } catch (e) {
      print("ao apagar no provider deu este erro:$e");
      throw e;
    }
  }
}
