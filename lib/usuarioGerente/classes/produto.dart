class Produtosavenda {
  final String id;
  final String nome;
  final List<String> categorias;
  final String descricao;
  final int estoque;
  final double preco;
  final double precoAntigo;
  final int quantiavendida;
  bool ativoParaExibir;
  final String urlImage;

  Produtosavenda({
    required this.categorias,
    required this.ativoParaExibir,
    required this.descricao,
    required this.estoque,
    required this.id,
    required this.nome,
    required this.preco,
    required this.quantiavendida,
    required this.urlImage,
    required this.precoAntigo,
  });

  // Converte o objeto Produtosavenda em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'categorias': categorias,
      'descricao': descricao,
      'estoque': estoque,
      'preco': preco,
      'precoAntigo': precoAntigo,
      'quantiavendida': quantiavendida,
      'ativoParaExibir': ativoParaExibir,
      'urlImage': urlImage,
    };
  }

  // Método para criar um objeto Produtosavenda a partir de um mapa
  factory Produtosavenda.fromMap(Map<String, dynamic> map) {
    return Produtosavenda(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      categorias: List<String>.from(map['categorias'] ?? []),
      descricao: map['descricao'] ?? '',
      estoque: map['estoque'] ?? 0,
      preco: (map['preco'] is int) ? (map['preco'] as int).toDouble() : map['preco'].toDouble(),
      precoAntigo: (map['precoAntigo'] is int) ? (map['precoAntigo'] as int).toDouble() : map['precoAntigo'].toDouble(),
      quantiavendida: map['quantiavendida'] ?? 0,
      ativoParaExibir: map['ativoParaExibir'] ?? false,
      urlImage: map['urlImage'] ?? '',
    );
  }
}
