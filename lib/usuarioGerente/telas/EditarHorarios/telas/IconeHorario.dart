import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/horarios.dart';
import 'package:Dimy/usuarioGerente/funcoes/ajusteHorarios.dart';
import 'package:provider/provider.dart';

class IconeHorario extends StatefulWidget {
  final Horarios horario;
  final String tipoDeDia;
  const IconeHorario({
    super.key,
    required this.horario,
    required this.tipoDeDia,
  });

  @override
  State<IconeHorario> createState() => _IconeHorarioState();
}

class _IconeHorarioState extends State<IconeHorario> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBool();
  }

  bool boolOfHour = true;
  void setBool() {
    setState(() {
      boolOfHour = widget.horario.isActive;
    });
  }

  Future<void> alterarOBool() async {
    setState(() {
      boolOfHour = !boolOfHour;
    });
    try {
      await Provider.of<Ajustehorarios>(context, listen: false).setNewBool(
        boolfinal: boolOfHour,
        idHorario: widget.horario.id,
        tipoDeDia: widget.tipoDeDia,
      );
    } catch (e) {
      print("ao alterar o bool do horario ocorreu este erro:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.schedule,
                  size: 18,
                  color: boolOfHour == true ? Colors.black : Colors.black26,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.horario.horario,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: boolOfHour == true ? Colors.black : Colors.black26,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  boolOfHour == true ? "Ativado" : "Desativado",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: alterarOBool,
                  child: Icon(
                    boolOfHour == true ? Icons.toggle_on : Icons.toggle_off,
                    size: 35,
                    color: boolOfHour == true ? Colors.black : Colors.black26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
