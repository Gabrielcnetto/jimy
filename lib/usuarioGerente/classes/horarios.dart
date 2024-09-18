import 'dart:math';

class Horarios {
  final String horario;
  final String id;
  final int quantidadeHorarios;

  Horarios({
    required this.quantidadeHorarios,
    required this.horario,
    required this.id,
  });

  // Método para converter a instância de Horarios para Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'horario': horario,
      'id': id,
      'quantidadeHorarios': quantidadeHorarios,
    };
  }

  // Método para criar uma instância de Horarios a partir de um Map<String, dynamic>
  factory Horarios.fromMap(Map<String, dynamic> map) {
    return Horarios(
      horario: map['horario'] ?? '',
      id: map['id'] ?? '',
      quantidadeHorarios: map['quantidadeHorarios'] ?? 0,
    );
  }
}
final List<Horarios> listaHorariosBase = [
  Horarios(
    quantidadeHorarios: 1,
    horario: "08:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "08:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "09:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "09:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "10:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "10:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "11:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "11:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "13:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "13:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "14:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "14:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "15:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "15:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "17:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "17:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "17:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "17:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "18:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "18:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "19:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "19:30",
    id: Random().nextDouble().toString(),
  ),
];
//fim de semana
final List<Horarios> listaHorariosBaseSabado = [
  Horarios(
    quantidadeHorarios: 1,
    horario: "08:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "08:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "09:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "09:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "10:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "10:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "11:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "11:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "13:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "13:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "14:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "14:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "15:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "15:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "17:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "17:30",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:00",
    id: Random().nextDouble().toString(),
  ),
  Horarios(
    quantidadeHorarios: 1,
    horario: "16:30",
    id: Random().nextDouble().toString(),
  ),

];
//para exibir na agenda do barbeiro
List<Horarios> listaHorariosFixos = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "20:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
   Horarios(
    horario: "20:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "21:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
      Horarios(
    horario: "21:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
       Horarios(
    horario: "22:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
];