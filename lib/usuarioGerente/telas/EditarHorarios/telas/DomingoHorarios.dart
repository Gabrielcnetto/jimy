import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/horarios.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/telas/EditarHorarios/telas/IconeHorario.dart';
import 'package:fiotrim/usuarioGerente/telas/EditarHorarios/telas/IconeHorarioDomingo.dart';
import 'package:fiotrim/usuarioGerente/telas/EditarHorarios/telas/IconeHorarioSabado.dart';
import 'package:provider/provider.dart';

class DomingoHorarios extends StatefulWidget {
  const DomingoHorarios({
    super.key,
  });

  @override
  State<DomingoHorarios> createState() => _DomingoHorariosState();
}

class _DomingoHorariosState extends State<DomingoHorarios> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).horariosSegunda.clear();
      Provider.of<Getsdeinformacoes>(context, listen: false).horariosSabado.clear();
    Provider.of<Getsdeinformacoes>(context, listen: false).loadHorariosDomingo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder(
          stream: Provider.of<Getsdeinformacoes>(context, listen: false)
              .getHorariosDomingo,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Dadosgeralapp().primaryColor,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Houve um erro...",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              List<Horarios> horariosList = snapshot.data as List<Horarios>;
              return Column(
                children: horariosList.map((item) {
                  return IconeHorarioDomingo(
                    horario: item,
                  );
                }).toList(),
              );
            }
            return Container();
          }),
    );
  }
}
