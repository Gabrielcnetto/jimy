class Pagamentos {
  final String id;
  final String photoIcon;
  final String name;

  Pagamentos({
    required this.id,
    required this.name,
    required this.photoIcon,
  });

  // Converte o objeto Pagamentos em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoIcon': photoIcon,
      'name': name,
    };
  }

  // Método para criar um objeto Pagamentos a partir de um mapa
  factory Pagamentos.fromMap(Map<String, dynamic> map) {
    return Pagamentos(
      id: map['id'] ?? '',
      photoIcon: map['photoIcon'] ?? '',
      name: map['name'] ?? '',
    );
  }

  // Sobrescreve == para comparar o conteúdo dos objetos
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pagamentos &&
        other.id == id &&
        other.photoIcon == photoIcon &&
        other.name == name;
  }

  // Sobrescreve hashCode para garantir que objetos iguais tenham o mesmo hash
  @override
  int get hashCode => id.hashCode ^ photoIcon.hashCode ^ name.hashCode;
}

final pagListPrincipal = [
  Pagamentos(
    id: "D1",
    name: "Dinheiro",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/cardIcons%2FmoneyIcon.png?alt=media&token=74967870-137f-45f5-a867-8fe9075dc5ef",
  ),
  Pagamentos(
    id: "M1",
    name: "Mastercard Crédito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/cardIcons%2Fmastercardicon.png?alt=media&token=b7f59d64-cfa4-4c0f-affa-47d64187413b",
  ),
  Pagamentos(
    id: "M2",
    name: "Mastercard Débito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/cardIcons%2Fmastercardicon.png?alt=media&token=b7f59d64-cfa4-4c0f-affa-47d64187413b",
  ),
  Pagamentos(
    id: "V1",
    name: "Visa Crédito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/cardIcons%2FvisaIcon.png?alt=media&token=3f4c8456-868a-44f4-8de4-8c2e2af0ea47",
  ),
  Pagamentos(
    id: "V2",
    name: "Visa Débito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/cardIcons%2FvisaIcon.png?alt=media&token=3f4c8456-868a-44f4-8de4-8c2e2af0ea47",
  ),
  Pagamentos(
    id: "P0",
    name: "PIX",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/cardIcons%2FpixIcon.png?alt=media&token=b94f99b9-a233-4cdc-a638-cf50eefadfd9",
  ),
];
