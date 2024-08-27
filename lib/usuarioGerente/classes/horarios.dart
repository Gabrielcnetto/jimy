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
