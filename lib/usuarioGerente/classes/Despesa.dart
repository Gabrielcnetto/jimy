class Despesa {
  final String id;
  final String name;
  final String diaCobranca;
  final String mesDeCobranca;
  final double preco;
  final bool recorrente;
  final bool despesaUnica;
  final DateTime dataDeCobrancaDatetime;
  final DateTime momentoFinalizacao;
  final bool pagoDeInicio;
  bool PagoEsteMes;

  Despesa({
    required this.PagoEsteMes,
    required this.dataDeCobrancaDatetime,
    required this.despesaUnica,
    required this.pagoDeInicio,
    required this.diaCobranca,
    required this.id,
    required this.mesDeCobranca,
    required this.momentoFinalizacao,
    required this.name,
    required this.preco,
    required this.recorrente,
  });

  // Converte o objeto em um mapa
  Map<String, dynamic> toMap() {
    return {
      'pagoDeInicio': pagoDeInicio,
      'id': id,
      'name': name,
      'diaCobranca': diaCobranca,
      'mesDeCobranca': mesDeCobranca,
      'preco': preco,
      'recorrente': recorrente,
      'despesaUnica': despesaUnica,
      'dataDeCobrancaDatetime': dataDeCobrancaDatetime.toIso8601String(),
      'momentoFinalizacao': momentoFinalizacao.toIso8601String(),
      'PagoEsteMes': PagoEsteMes,
    };
  }

  // Método para criar um objeto a partir de um mapa
  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      pagoDeInicio: map["pagoDeInicio"] ?? false,
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      diaCobranca: map['diaCobranca'] ?? '',
      mesDeCobranca: map['mesDeCobranca'] ?? '',
      preco: (map['preco'] is int)
          ? (map['preco'] as int).toDouble()
          : map['preco'].toDouble(),
      recorrente: map['recorrente'] ?? false,
      despesaUnica: map['despesaUnica'] ?? false,
      dataDeCobrancaDatetime: DateTime.parse(map['dataDeCobrancaDatetime']),
      momentoFinalizacao: DateTime.parse(map['momentoFinalizacao']),
      PagoEsteMes: map['PagoEsteMes'] ?? false,
    );
  }
}
