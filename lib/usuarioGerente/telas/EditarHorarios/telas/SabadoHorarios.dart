import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/EditarHorarios/telas/IconeHorario.dart';
import 'package:jimy/usuarioGerente/telas/EditarHorarios/telas/IconeHorarioSabado.dart';
import 'package:provider/provider.dart';

class SabadoHorarios extends StatefulWidget {
  const SabadoHorarios({
    super.key,
  });

  @override
  State<SabadoHorarios> createState() => _SabadoHorariosState();
}

class _SabadoHorariosState extends State<SabadoHorarios> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).horariosSegunda.clear();
    Provider.of<Getsdeinformacoes>(context, listen: false).loadHorariosSabado();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder(
          stream: Provider.of<Getsdeinformacoes>(context, listen: false)
              .getHorariosSabado,
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
                  return IconeHorarioSabado(
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
