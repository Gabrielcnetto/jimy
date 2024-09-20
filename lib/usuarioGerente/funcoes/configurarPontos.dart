import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Configurarpontos with ChangeNotifier{
  final database = FirebaseFirestore.instance;
  final authConfigs = FirebaseAuth.instance;

  Future<void>sentPoints({required int TotalPontos })async{
    try{
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

        //enviando
        final databasePubPoints = await database.collection("PontuacoesConfiguradas").doc(idBarbearia).set({
          "Pontos": TotalPontos,
        });
      } catch (e) {
        print("ao pegar o id da barbearia ocorreu isto:$e");
      }
    }catch(e){
      print("Ao enviar os pontos deu isso:$e");
      throw e;
    }
  }
}