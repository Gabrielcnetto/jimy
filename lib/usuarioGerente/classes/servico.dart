class Servico {
  final String id;
  final String name;
  final double price;
  final int tempolevado;
  final int quantiaEscolhida;
  bool active;

  Servico({
    required this.quantiaEscolhida,
    required this.active,
    required this.id,
    required this.tempolevado,
    required this.name,
    required this.price,
  });

  // Método para converter o objeto para um mapa
  Map<String, dynamic> toMap() {
    return {
      'quantiaEscolhida': quantiaEscolhida,
      'id': id,
      'name': name,
      'price': price,
      'tempolevado': tempolevado,
      'active': active,
    };
  }

  // Método para criar um objeto a partir de um mapa
  factory Servico.fromMap(Map<String, dynamic> map) {
  return Servico(
    quantiaEscolhida: map['quantiaEscolhida'] ?? 0,
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    price: map['price'] != null 
        ? (map['price'] is int) 
            ? (map['price'] as int).toDouble() 
            : map['price'] 
        : 0.0,  // Define um valor padrão caso seja null
    tempolevado: map['tempolevado'] ?? 0,
    active: map['active'] ?? false,
  );
  }
}
