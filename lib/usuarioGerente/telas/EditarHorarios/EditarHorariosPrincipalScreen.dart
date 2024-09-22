import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/telas/EditarHorarios/telas/DomingoHorarios.dart';
import 'package:fiotrim/usuarioGerente/telas/EditarHorarios/telas/SabadoHorarios.dart';
import 'package:fiotrim/usuarioGerente/telas/EditarHorarios/telas/Semana.dart';

class EditarHorariosPrincipalEscreen extends StatefulWidget {
  const EditarHorariosPrincipalEscreen({super.key});

  @override
  State<EditarHorariosPrincipalEscreen> createState() =>
      _EditarHorariosPrincipalEscreenState();
}

class _EditarHorariosPrincipalEscreenState
    extends State<EditarHorariosPrincipalEscreen> {
  bool horariosSemana = true;
  bool horariosSabado = false;
  bool horariosDomingo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          // Primeiro Positioned para o header
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                              color: Dadosgeralapp().primaryColor,
                            ),
                          ),
                          SizedBox(
                              width: 10), // Espaçamento entre ícone e texto
                          Text(
                            "Seus Horários",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Os horários ativados aqui, são exibidos na sua página exibida aos clientes no App da ${Dadosgeralapp().nomeSistema}. Para que os seus clientes não agendem fora do seu horário de trabalho.",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            horariosSemana = true;
                            horariosSabado = false;
                            horariosDomingo = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: horariosSemana == true
                              ? Dadosgeralapp().primaryColor
                              : Colors.grey.shade100,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Seg-Sex",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: horariosSemana == true ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            horariosSemana = false;
                            horariosSabado = true;
                            horariosDomingo = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: horariosSabado == true
                              ? Dadosgeralapp().primaryColor
                              : Colors.grey.shade100,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Sábado",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: horariosSabado == true ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            horariosSemana = false;
                            horariosSabado = false;
                            horariosDomingo = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: horariosDomingo == true
                              ? Dadosgeralapp().primaryColor
                              : Colors.grey.shade100,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Domingo",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: horariosDomingo == true ? Colors.white:Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Segundo Positioned para o Column com "teste"
          Positioned(
            top: MediaQuery.of(context).size.height * 0.23,
            left: 15,
            right: 15,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.75,
             
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(horariosSemana == true)
                    SemanaHorarios(),
                    if(horariosSabado == true)
                    SabadoHorarios(),
                    if(horariosDomingo == true)
                    DomingoHorarios(),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
