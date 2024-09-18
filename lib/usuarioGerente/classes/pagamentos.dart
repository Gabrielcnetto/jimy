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
        "https://firebasestorage.googleapis.com/v0/b/jimyappoficial.appspot.com/o/cardIcons%2FmoneyIcon.png?alt=media&token=eb399854-ac50-4ffb-ad53-9929fb901cbc",
  ),
  Pagamentos(
    id: "M1",
    name: "Mastercard Crédito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/jimyappoficial.appspot.com/o/cardIcons%2FMastercardicon.png?alt=media&token=d7601d82-e6bf-4247-931b-09c00930ddf6",
  ),
  Pagamentos(
    id: "M2",
    name: "Mastercard Débito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/jimyappoficial.appspot.com/o/cardIcons%2FMastercardicon.png?alt=media&token=d7601d82-e6bf-4247-931b-09c00930ddf6",
  ),
  Pagamentos(
    id: "V1",
    name: "Visa Crédito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/jimyappoficial.appspot.com/o/cardIcons%2FVisaIcon.png?alt=media&token=ae31c680-dedc-4a2f-a9a3-ce425e1e938d",
  ),
  Pagamentos(
    id: "V2",
    name: "Visa Débito",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/jimyappoficial.appspot.com/o/cardIcons%2FVisaIcon.png?alt=media&token=ae31c680-dedc-4a2f-a9a3-ce425e1e938d",
  ),
  Pagamentos(
    id: "P0",
    name: "PIX",
    photoIcon:
        "https://firebasestorage.googleapis.com/v0/b/jimyappoficial.appspot.com/o/cardIcons%2Fpixicon.png?alt=media&token=c5249951-55bc-4338-8ebf-ad89f0da8045",
  ),
];
