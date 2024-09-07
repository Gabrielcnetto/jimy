import 'package:jimy/usuarioGerente/classes/produto.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';

class Comanda {
  // Strings
  final String id;
  final String nomeCliente;
  final String idBarbearia;
  String? idBarbeiroQueCriou;
  final List<Servico> servicosFeitos;
  final List<Produtosavenda> produtosVendidos;

  // Double
  final double valorTotalComanda;
  final DateTime dataFinalizacao;

  Comanda({
    required this.dataFinalizacao,
    required this.id,
    required this.idBarbearia,
    required this.idBarbeiroQueCriou,
    required this.nomeCliente,
    required this.produtosVendidos,
    required this.servicosFeitos,
    required this.valorTotalComanda,
  });

  // Converte o objeto Comanda em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeCliente': nomeCliente,
      'idBarbearia': idBarbearia,
      'idBarbeiroQueCriou': idBarbeiroQueCriou,
      'servicosFeitos': servicosFeitos.map((servico) => servico.toMap()).toList(),
      'produtosVendidos': produtosVendidos.map((produto) => produto.toMap()).toList(),
      'valorTotalComanda': valorTotalComanda,
      'dataFinalizacao': dataFinalizacao.toIso8601String(),
    };
  }

  // Método para criar um objeto Comanda a partir de um mapa
  factory Comanda.fromMap(Map<String, dynamic> map) {
    return Comanda(
      id: map['id'] ?? '',
      nomeCliente: map['nomeCliente'] ?? '',
      idBarbearia: map['idBarbearia'] ?? '',
      idBarbeiroQueCriou: map['idBarbeiroQueCriou'],
      servicosFeitos: List<Servico>.from(
        map['servicosFeitos']?.map((servicoMap) => Servico.fromMap(servicoMap)) ?? [],
      ),
      produtosVendidos: List<Produtosavenda>.from(
        map['produtosVendidos']?.map((produtoMap) => Produtosavenda.fromMap(produtoMap)) ?? [],
      ),
      valorTotalComanda: (map['valorTotalComanda'] is int)
          ? (map['valorTotalComanda'] as int).toDouble()
          : map['valorTotalComanda'].toDouble(),
      dataFinalizacao: DateTime.parse(map['dataFinalizacao']),
    );
  }
}
