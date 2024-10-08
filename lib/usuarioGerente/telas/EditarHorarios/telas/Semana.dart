import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/horarios.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/telas/EditarHorarios/telas/IconeHorario.dart';
import 'package:provider/provider.dart';

class SemanaHorarios extends StatefulWidget {
  const SemanaHorarios({
    super.key,
  });

  @override
  State<SemanaHorarios> createState() => _SemanaHorariosState();
}

class _SemanaHorariosState extends State<SemanaHorarios> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).loadHorariosSemana();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder(
          stream: Provider.of<Getsdeinformacoes>(context, listen: false)
              .getHorariosSemana,
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
                  return IconeHorario(horario: item,tipoDeDia: "horarioSemana",);
                }).toList(),
              );
            }
            return Container();
          }),
    );
  }
}
