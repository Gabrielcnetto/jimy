import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fiotrim/usuarioGerente/classes/horarios.dart';

class Ajustehorarios with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final AuthConfigs = FirebaseAuth.instance;

  Future<void> setNewBool({
    required bool boolfinal,
    required String idHorario,
    required String tipoDeDia,
  }) async {
    try {
      final String uidUser = AuthConfigs.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      if (idBarberaria == null) {
        print('ID da barbearia não encontrado!');
        return; // Saia do método se o ID não for encontrado
      }

      // Obtém o documento da barbearia
      final barberDoc =
          await database.collection("Barbearias").doc(idBarberaria).get();
      if (!barberDoc.exists) {
        print('Documento da barbearia não encontrado!');
        return;
      }

      // Pega os dados do documento
      Map<String, dynamic> barberData =
          barberDoc.data() as Map<String, dynamic>;
      List<dynamic> horarioSemanaData = barberData['horarioSemana'] ?? [];

      // Converte os dados para uma lista de instâncias de Horarios
      List<Horarios> horarioSemana = horarioSemanaData.map((item) {
        return Horarios.fromMap(item as Map<String, dynamic>);
      }).toList();

      // Atualiza o campo isActive no item com o idHorario correspondente
      List<Horarios> updatedHorarios = horarioSemana.map((item) {
        if (item.id == idHorario) {
          return Horarios(
            horario: item.horario,
            id: item.id,
            quantidadeHorarios: item.quantidadeHorarios,
            isActive: boolfinal,
          );
        }
        return item;
      }).toList();

      // Converte a lista de Horarios de volta para Map<String, dynamic>
      List<Map<String, dynamic>> updatedHorariosData =
          updatedHorarios.map((item) {
        return item.toMap();
      }).toList();

      // Atualiza o documento com o array modificado
      await database.collection("Barbearias").doc(idBarberaria).update({
        'horarioSemana': updatedHorariosData,
      });

      print("Atualização concluída com sucesso!");
    } catch (e) {
      print("Erro ao ajustar o bool do horário: $e");
      throw e;
    }
  }
  Future<void> setNewBoolSabado({
    required bool boolfinal,
    required String idHorario,
   
  }) async {
    try {
      final String uidUser = AuthConfigs.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      if (idBarberaria == null) {
        print('ID da barbearia não encontrado!');
        return; // Saia do método se o ID não for encontrado
      }

      // Obtém o documento da barbearia
      final barberDoc =
          await database.collection("Barbearias").doc(idBarberaria).get();
      if (!barberDoc.exists) {
        print('Documento da barbearia não encontrado!');
        return;
      }

      // Pega os dados do documento
      Map<String, dynamic> barberData =
          barberDoc.data() as Map<String, dynamic>;
      List<dynamic> horarioSemanaData = barberData['horarioSabado'] ?? [];

      // Converte os dados para uma lista de instâncias de Horarios
      List<Horarios> horarioSemana = horarioSemanaData.map((item) {
        return Horarios.fromMap(item as Map<String, dynamic>);
      }).toList();

      // Atualiza o campo isActive no item com o idHorario correspondente
      List<Horarios> updatedHorarios = horarioSemana.map((item) {
        if (item.id == idHorario) {
          return Horarios(
            horario: item.horario,
            id: item.id,
            quantidadeHorarios: item.quantidadeHorarios,
            isActive: boolfinal,
          );
        }
        return item;
      }).toList();

      // Converte a lista de Horarios de volta para Map<String, dynamic>
      List<Map<String, dynamic>> updatedHorariosData =
          updatedHorarios.map((item) {
        return item.toMap();
      }).toList();

      // Atualiza o documento com o array modificado
      await database.collection("Barbearias").doc(idBarberaria).update({
        'horarioSabado': updatedHorariosData,
      });

      print("Atualização concluída com sucesso!");
    } catch (e) {
      print("Erro ao ajustar o bool do horário: $e");
      throw e;
    }
  }
  Future<void> setNewBoolDomingo({
    required bool boolfinal,
    required String idHorario,
   
  }) async {
    try {
      final String uidUser = AuthConfigs.currentUser!.uid;
      String? idBarberaria;

      // Pega o ID da barbearia
      final userDoc = await database.collection("usuarios").doc(uidUser).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        idBarberaria = data['idBarbearia'];
      }

      if (idBarberaria == null) {
        print('ID da barbearia não encontrado!');
        return; // Saia do método se o ID não for encontrado
      }

      // Obtém o documento da barbearia
      final barberDoc =
          await database.collection("Barbearias").doc(idBarberaria).get();
      if (!barberDoc.exists) {
        print('Documento da barbearia não encontrado!');
        return;
      }

      // Pega os dados do documento
      Map<String, dynamic> barberData =
          barberDoc.data() as Map<String, dynamic>;
      List<dynamic> horarioSemanaData = barberData['horarioDomingo'] ?? [];

      // Converte os dados para uma lista de instâncias de Horarios
      List<Horarios> horarioSemana = horarioSemanaData.map((item) {
        return Horarios.fromMap(item as Map<String, dynamic>);
      }).toList();

      // Atualiza o campo isActive no item com o idHorario correspondente
      List<Horarios> updatedHorarios = horarioSemana.map((item) {
        if (item.id == idHorario) {
          return Horarios(
            horario: item.horario,
            id: item.id,
            quantidadeHorarios: item.quantidadeHorarios,
            isActive: boolfinal,
          );
        }
        return item;
      }).toList();

      // Converte a lista de Horarios de volta para Map<String, dynamic>
      List<Map<String, dynamic>> updatedHorariosData =
          updatedHorarios.map((item) {
        return item.toMap();
      }).toList();

      // Atualiza o documento com o array modificado
      await database.collection("Barbearias").doc(idBarberaria).update({
        'horarioDomingo': updatedHorariosData,
      });

      print("Atualização concluída com sucesso!");
    } catch (e) {
      print("Erro ao ajustar o bool do horário: $e");
      throw e;
    }
  }
}
