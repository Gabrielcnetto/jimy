import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LinhaTempoProfissionalSelecionado extends StatelessWidget {
  const LinhaTempoProfissionalSelecionado({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimelineTile(
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
                        "10:30",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    //Aqui coloca um expanded com um .map dos horarios (eles vao carregando pra baixo dai )
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
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
        )
      ],
    );
  }
}
