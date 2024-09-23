import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/barbeiros.dart';

class Criarfuncionario with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authconfigs = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future<void> CreateProfissional({
    required String email,
    required String senha,
    required String userName,
    required String IddaBarbearia,
    required File fotoUpload,
    required double porcentagemPorCortes,
    required double porcentagemporProdutos,
    required String senhaGerente,
  }) async {
    try {
      final emailtext = await authconfigs.currentUser!.email.toString();
      //fim
      //separa
      //Criando a conta do usuario para ele logar - inicio
      final UserCredential userCredential =
          await authconfigs.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      //Criando a conta do usuario para ele logar - Fim
      //pegando nome barbearia
      
      String? nomeBarbeariaFinal;

      await database.collection("Barbearias").doc(IddaBarbearia).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          nomeBarbeariaFinal = data['nomeBarbearia'];
        }
      });
      //pegando nome barbearia
      String userIdCreate = userCredential.user!.uid;
      //enviando a foto de perfil ao db e retornando link - inicio
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("userProfilePhotos/${userIdCreate}");
      UploadTask uploadTask = ref.putFile(fotoUpload);
      await uploadTask.whenComplete(() => null);
      String imageProfileImage = await ref.getDownloadURL();

      //enviando a foto de perfil ao db e retornando link - fim

      //criando o barbeiro que vai ser enviado ao db - inicio
      final String idBarbeiroGetForDb = Random().nextDouble().toString();
      final Barbeiros barber = Barbeiros(
        ativoParaClientes: true,
        totalCortes: 0,
        avaliacaoFinal: 0.0,
        totalComissao: 0.0,
        emailAcesso: email,
        id: idBarbeiroGetForDb,
        name: userName,
        porcentagemCortes: porcentagemPorCortes,
        porcentagemProdutos: porcentagemporProdutos,
        senhaAcesso: senha,
        urlImageFoto: imageProfileImage ?? Dadosgeralapp().defaultAvatarImage,
      );
//criando o barbeiro que vai ser enviado ao db - fim

      final pubNewCliente =
          await database.collection("usuarios").doc(userIdCreate).set({
        //identificador pra fazer ele um cliente
        "clienteNormal": false,
        "idBarbearia": IddaBarbearia,
        "donoBarbearia": false,
        "funcionarioBarbearia": true,
        "idBarbeiroGetForDb": idBarbeiroGetForDb,
        "distribuidor": false,
        "nomeBarbearia": nomeBarbeariaFinal,
        //atributos para usuario utilizar e visualizar e localizar o perfil
        'PhoneNumber': "",
        'userIdDatabase': userIdCreate,
        "urlPerfilImage":
            imageProfileImage ?? Dadosgeralapp().defaultAvatarImage,
        "Dimypoints": 0,
        "userName": userName,

        "email": email,
        "senha": senha,
        "cidade": "",
        "cep": "",

        //pagamentos
        'saldoConta': 0.0,
      });
      await database.collection("Barbearias").doc(IddaBarbearia).update({
        "profissionais": FieldValue.arrayUnion([barber.toMap()]),
      });
      //após, enviar ele ao perfil da barbearia.

      await authconfigs.signInWithEmailAndPassword(
        email: emailtext,
        password: senhaGerente,
      );
    } catch (e) {
      print("Houve um erro ao criar o profissional e adicionar:$e");
      throw e;
    }
  }

  //Area de edição
  Future<void> alterarFotoDePerfilBarbeiro({
    required String idBarbearia,
    required File fotoNova,
    required String idBarbeiro,
  }) async {
    try {
      // Referência e upload da nova foto
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("userProfilePhotos/${idBarbeiro}");
      UploadTask uploadTask = ref.putFile(fotoNova);
      await uploadTask.whenComplete(() => null);
      String imageProfileImage = await ref.getDownloadURL();

      // Passo 1: Recupera o documento da barbearia
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

      // Atualiza o campo da URL da foto do barbeiro específico
      for (int i = 0; i < updatedProfissionais.length; i++) {
        if (updatedProfissionais[i]['id'] == idBarbeiro) {
          updatedProfissionais[i]['urlImageFoto'] = imageProfileImage;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });
    } catch (e) {
      print("Erro ao alterar a foto: $e");
      throw e;
    }
  }

  //
  Future<void> deletarBarbeiro({
    required String idBarbearia,
    required String idBarbeiro,
  }) async {
    try {
      // Passo 1: Recupera o documento da barbearia
      DocumentSnapshot documentSnapshot =
          await database.collection('Barbearias').doc(idBarbearia).get();

      if (!documentSnapshot.exists) {
        print('Documento não encontrado!');
        return;
      }

      // Passo 2: Encontre o barbeiro e a lista de profissionais
      List<dynamic> profissionais = await documentSnapshot.get('profissionais');
      List<Map<String, dynamic>> updatedProfissionais =
          await List.from(profissionais);

      // Filtra a lista para remover o barbeiro com o idBarbeiro
      updatedProfissionais
          .removeWhere((profissional) => profissional['id'] == idBarbeiro);

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });

      // Opcional: Exclui a foto do barbeiro do Firebase Storage, se necessário
    } catch (e) {
      print("Erro ao deletar o barbeiro: $e");
      throw e;
    }
  }

  //
  Future<void> alterarNomeProfissional({
    required String idBarbearia,
    required String newName,
    required String idBarbeiro,
  }) async {
    try {
      // Referência e upload da nova foto

      // Passo 1: Recupera o documento da barbearia
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

      // Atualiza o campo da URL da foto do barbeiro específico
      for (int i = 0; i < updatedProfissionais.length; i++) {
        if (updatedProfissionais[i]['id'] == idBarbeiro) {
          updatedProfissionais[i]['name'] = newName;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });
    } catch (e) {
      print("Erro ao alterar a foto: $e");
      throw e;
    }
  }

  //
  Future<void> updatePorcentagemCortes({
    required String idBarbearia,
    required double porcentagemCortes,
    required String idBarbeiro,
  }) async {
    try {
      // Referência e upload da nova foto

      // Passo 1: Recupera o documento da barbearia
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

      // Atualiza o campo da URL da foto do barbeiro específico
      for (int i = 0; i < updatedProfissionais.length; i++) {
        if (updatedProfissionais[i]['id'] == idBarbeiro) {
          updatedProfissionais[i]['porcentagemCortes'] = porcentagemCortes;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });
    } catch (e) {
      print("Erro ao alterar a foto: $e");
      throw e;
    }
  }

  //
  Future<void> updatePorcentagemprodutos({
    required String idBarbearia,
    required double porcentagemProdutos,
    required String idBarbeiro,
  }) async {
    try {
      // Referência e upload da nova foto

      // Passo 1: Recupera o documento da barbearia
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

      // Atualiza o campo da URL da foto do barbeiro específico
      for (int i = 0; i < updatedProfissionais.length; i++) {
        if (updatedProfissionais[i]['id'] == idBarbeiro) {
          updatedProfissionais[i]['porcentagemProdutos'] = porcentagemProdutos;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });
    } catch (e) {
      print("Erro ao alterar a foto: $e");
      throw e;
    }
  }

  Future<void> AtualizarAtividade({
    required String idBarbearia,
    required bool ativoOuNao,
    required String idBarbeiro,
  }) async {
    try {
      // Referência e upload da nova foto

      // Passo 1: Recupera o documento da barbearia
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

      // Atualiza o campo da URL da foto do barbeiro específico
      for (int i = 0; i < updatedProfissionais.length; i++) {
        if (updatedProfissionais[i]['id'] == idBarbeiro) {
          updatedProfissionais[i]['ativoParaClientes'] = ativoOuNao;
          break;
        }
      }

      // Passo 3: Atualize o documento com a lista modificada
      await database.collection('Barbearias').doc(idBarbearia).update({
        'profissionais': updatedProfissionais,
      });
    } catch (e) {
      print("Erro ao alterar a foto: $e");
      throw e;
    }
  }
}
