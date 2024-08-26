// No seu model Barbeiros, adicione um método para converter o objeto em um mapa.
class Barbeiros {
  // Atributos
  final double totalCortes;
  final double avaliacaoFinal;
  final double totalComissao;
  final String emailAcesso;
  final String id;
  final String name;
  final double porcentagemCortes;
  final double porcentagemProdutos;
  final String senhaAcesso;
  final String urlImageFoto;
  bool ativoParaClientes;

  // Construtor
  Barbeiros({
    required this.totalCortes,
    required this.avaliacaoFinal,
    required this.ativoParaClientes,
    required this.totalComissao,
    required this.emailAcesso,
    required this.id,
    required this.name,
    required this.porcentagemCortes,
    required this.porcentagemProdutos,
    required this.senhaAcesso,
    required this.urlImageFoto,
  });

  // Converte o objeto em um mapa
  Map<String, dynamic> toMap() {
    return {
      'totalCortes': totalCortes,
      'avaliacaoFinal': avaliacaoFinal,
      'totalComissao': totalComissao,
      'emailAcesso': emailAcesso,
      'id': id,
      'name': name,
      'porcentagemCortes': porcentagemCortes,
      'porcentagemProdutos': porcentagemProdutos,
      'senhaAcesso': senhaAcesso,
      'urlImageFoto': urlImageFoto,
      'ativoParaClientes':ativoParaClientes,
    };
  }

  // Método para criar um objeto a partir de um mapa (opcional)
  factory Barbeiros.fromMap(Map<String, dynamic> map) {
    return Barbeiros(
      ativoParaClientes: map['ativoParaClientes'] ?? false,
      totalCortes: (map['totalCortes'] is int)
          ? (map['totalCortes'] as int).toDouble()
          : map['totalCortes'].toDouble(),
      avaliacaoFinal: (map['avaliacaoFinal'] is int)
          ? (map['avaliacaoFinal'] as int).toDouble()
          : map['avaliacaoFinal'].toDouble(),
      totalComissao: (map['totalComissao'] is int)
          ? (map['totalComissao'] as int).toDouble()
          : map['totalComissao'].toDouble(),
      emailAcesso: map['emailAcesso'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      porcentagemCortes: (map['porcentagemCortes'] is int)
          ? (map['porcentagemCortes'] as int).toDouble()
          : map['porcentagemCortes'].toDouble(),
      porcentagemProdutos: (map['porcentagemProdutos'] is int)
          ? (map['porcentagemProdutos'] as int).toDouble()
          : map['porcentagemProdutos'].toDouble(),
      senhaAcesso: map['senhaAcesso'] ?? '',
      urlImageFoto: map['urlImageFoto'] ?? '',
    );
  }
}
