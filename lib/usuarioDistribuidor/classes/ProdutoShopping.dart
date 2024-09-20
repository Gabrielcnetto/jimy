class ProdutoShopping {
  final String id;
  final bool usado;
  final String nome;
  final String marca;
  final List<String> categorias;
  final String descricao;
  final int estoque;
  List<String> urlImagensParaExibir;
  final double precoAntigo;
  final int quantiavendida;
  bool ativoParaExibir;
  final String urlImageFront;
  final int totalVisualizacoes;
  final int totalCliques;
  final double precoParaBarbeiros;
  final double precoParaClientes; 
  List<String>palavrasChaves;
  bool exibirParaBarbeiros;
  bool exibirParaClientes;
  ProdutoShopping({
    required this.marca,
    required this.usado,
    required this.palavrasChaves,
    required this.exibirParaBarbeiros,
    required this.exibirParaClientes,
    required this.categorias,
    required this.ativoParaExibir,
    required this.descricao,
    required this.estoque,
    required this.id,
    required this.nome,
    required this.precoParaBarbeiros,
    required this.quantiavendida,
    required this.urlImagensParaExibir,
    required this.precoAntigo,
    required this.precoParaClientes,
    required this.urlImageFront,
    this.totalVisualizacoes = 0,
    this.totalCliques = 0,
  });

  // Converte o objeto ProdutoShopping em um mapa
  Map<String, dynamic> toMap() {
    return {
      'usado': usado,
      'id': id,
      'marca':marca,
      'palavrasChaves': palavrasChaves,
      'nome': nome,
      'categorias': categorias,
      'descricao': descricao,
      'estoque': estoque,
      'precoAntigo': precoAntigo,
      'quantiavendida': quantiavendida,
      'ativoParaExibir': ativoParaExibir,
      'urlImageFront': urlImageFront,
      'urlImagensParaExibir': urlImagensParaExibir,
      'totalVisualizacoes': totalVisualizacoes,
      'totalCliques': totalCliques,
      'precoParaBarbeiros': precoParaBarbeiros,
      'precoParaClientes': precoParaClientes,
      'exibirParaBarbeiros':exibirParaBarbeiros,
      'exibirParaClientes': exibirParaClientes,
    };
  }

  // Método para criar um objeto ProdutoShopping a partir de um mapa
  factory ProdutoShopping.fromMap(Map<String, dynamic> map) {
    return ProdutoShopping(
      marca: map['marca'] ?? '',
      usado: map['usado'] ?? false,
      palavrasChaves: List<String>.from(map['palavrasChaves'] ?? []),
      exibirParaBarbeiros: map['exibirParaBarbeiros'] ?? false,
      exibirParaClientes: map['exibirParaClientes'] ?? false,
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      categorias: List<String>.from(map['categorias'] ?? []),
      descricao: map['descricao'] ?? '',
      estoque: map['estoque'] ?? 0,
      precoAntigo: (map['precoAntigo'] is int)
          ? (map['precoAntigo'] as int).toDouble()
          : map['precoAntigo'].toDouble(),
      quantiavendida: map['quantiavendida'] ?? 0,
      ativoParaExibir: map['ativoParaExibir'] ?? false,
      urlImageFront: map['urlImageFront'] ?? '',
      urlImagensParaExibir: List<String>.from(map['urlImagensParaExibir'] ?? []),
      totalVisualizacoes: map['totalVisualizacoes'] ?? 0,
      totalCliques: map['totalCliques'] ?? 0,
      precoParaBarbeiros: (map['precoParaBarbeiros'] is int)
          ? (map['precoParaBarbeiros'] as int).toDouble()
          : map['precoParaBarbeiros'].toDouble(),
      precoParaClientes: (map['precoParaClientes'] is int)
          ? (map['precoParaClientes'] as int).toDouble()
          : map['precoParaClientes'].toDouble(),
    );
  }
}
