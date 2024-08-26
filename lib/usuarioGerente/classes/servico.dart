class Servico {
  final String id;
  final String name;
  final double price;
  final int tempolevado;
  bool active;

  Servico({
    required this.active,
    required this.id,
    required this.tempolevado,
    required this.name,
    required this.price,
  });

  // Método para converter o objeto para um mapa
  Map<String, dynamic> toMap() {
    return {
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
      id: map['id'],
      name: map['name'],
      price: map['price'],
      tempolevado: map['tempolevado'],
      active: map['active'],
    );
  }
}
