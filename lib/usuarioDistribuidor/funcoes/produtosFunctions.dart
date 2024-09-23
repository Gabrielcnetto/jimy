import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Dimy/usuarioDistribuidor/classes/ProdutoShopping.dart';

class Produtosfunctions with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authConfigs = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future<void> pubNewProdutct({
    required ProdutoShopping produto,
    required List<File> listaImges,
  }) async {
    String? idDistribuidora;
    String? nomeDistribuidora;
    String? urlImageDistribuidora;
    List<String> imageUrls = [];
    try {
      final String uidUser = await authConfigs.currentUser!.uid;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          idDistribuidora = data['idDistribuidora'];
        }
        return idDistribuidora;
      });
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          nomeDistribuidora = data['nomeDistribuidora'];
          urlImageDistribuidora = data['urlPerfilImage'];
        }
        return nomeDistribuidora;
      });
      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          urlImageDistribuidora = data['urlPerfilImage'];
        }
        return urlImageDistribuidora;
      });
      //agora publicando o produto
      for (var image in listaImges) {
        // Define o caminho do arquivo no Storage (ex: distribuidoras/{id}/produtos/{idProduto}/image{index}.jpg)
        String imagePath =
            "distribuidoras/$idDistribuidora/produtos/${produto.id}/${DateTime.now().millisecondsSinceEpoch}.jpg";

        // Faz o upload da imagem para o Storage
        final storageRef = FirebaseStorage.instance.ref().child(imagePath);
        final uploadTask = await storageRef.putFile(image);

        // Obtém a URL de download da imagem
        String downloadUrl = await storageRef.getDownloadURL();

        // Adiciona a URL à lista de URLs
        imageUrls.add(downloadUrl);
      }
      final pubProduct = database
          .collection("ProdutosVendaDistribuidoras")
          .doc(idDistribuidora)
          .collection("lista")
          .doc(produto.id)
          .set({
        "id": produto.id,
        "urlImageDistribuidora": urlImageDistribuidora,
        "nomeDistribuidora": nomeDistribuidora,
        "idDistribuidora": idDistribuidora,
        "usado": produto.usado,
        "nome": produto.nome,
        "marca": produto.marca,
        "categorias": produto.categorias,
        "descricao": produto.descricao,
        "estoque": produto.estoque,
        "urlImagensParaExibir": imageUrls,
        "precoAntigo": produto.precoAntigo,
        "quantiavendida": produto.quantiavendida,
        "ativoParaExibir": produto.ativoParaExibir,
        "urlImageFront": imageUrls[0],
        "totalVisualizacoes": produto.totalVisualizacoes,
        "totalCliques": produto.totalCliques,
        "precoParaBarbeiros": produto.precoParaBarbeiros,
        "precoParaClientes": produto.precoParaClientes,
        "palavrasChaves": produto.palavrasChaves,
        "exibirParaBarbeiros": produto.exibirParaBarbeiros,
        "exibirParaClientes": produto.exibirParaClientes,
      });
    } catch (e) {
      print("ao pegar o id da barbearia ocorreu isto:$e");
      throw e;
    }
  }

  final StreamController<List<ProdutoShopping>> _produtosAvendaStream =
      StreamController<List<ProdutoShopping>>.broadcast();

  Stream<List<ProdutoShopping>> get ProdutosAvendaStream =>
      _produtosAvendaStream.stream;
  List<ProdutoShopping> _produtosAvenda = [];
  List<ProdutoShopping> get produtosAvenda => [..._produtosAvenda];
  Future<void> LoadProductsBarbearia() async {
    print("entrei no load");
    try {
      String? idDistribuidora;

      // Obtendo o ID da distribuidora
      final String uidUser = await authConfigs.currentUser!.uid;
      DocumentSnapshot userDoc =
          await database.collection("usuarios").doc(uidUser).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idDistribuidora = data['idDistribuidora'];
      }

      if (idDistribuidora == null) {
        print("ID da distribuidora não encontrado.");
        return;
      }

      print("entrei no try");
      // Consultando a coleção de produtos pela nova estrutura
      QuerySnapshot querySnapshot = await database
          .collection('ProdutosVendaDistribuidoras')
          .doc(idDistribuidora)
          .collection("lista")
          .get();

      _produtosAvenda = querySnapshot.docs.map((doc) {
        print("entrei no map do doc");
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        // Criando o objeto ProdutoShopping a partir do mapa
        return ProdutoShopping.fromMap(data!);
      }).toList();

      // Emitindo a lista atualizada para o stream
      _produtosAvendaStream.add(_produtosAvenda);
      print("o length da lista de produtos é ${_produtosAvenda.length}");

      // Ordenar os dados pela quantidade de cliques
      _produtosAvenda.sort((a, b) {
        return b.totalCliques.compareTo(a.totalCliques);
      });
    } catch (e) {
      print("houve um erro: $e");
    }
  }
}
