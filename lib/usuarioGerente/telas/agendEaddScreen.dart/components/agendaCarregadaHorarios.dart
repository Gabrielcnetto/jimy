import 'package:flutter/material.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LinhaTempoProfissionalSelecionado extends StatefulWidget {
  const LinhaTempoProfissionalSelecionado({super.key});

  @override
  State<LinhaTempoProfissionalSelecionado> createState() =>
      _LinhaTempoProfissionalSelecionadoState();
}

class _LinhaTempoProfissionalSelecionadoState
    extends State<LinhaTempoProfissionalSelecionado> {
  List<Horarios> _horariosListFixa = listaHorariosFixos;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _horariosListFixa.map((item) {
        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0,
                axis: TimelineAxis.vertical,
                indicatorStyle: IndicatorStyle(
                  color: Colors.grey.shade300,
                  height: 5,
                ),
                beforeLineStyle: LineStyle(
                  color: Colors.grey.shade300,
                  thickness: 2,
                ),
                endChild: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 100,
                            child: Text(
                              item.horario,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        // Se não houver cortes, exibe "Horário Disponível"
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Horário Disponível",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
