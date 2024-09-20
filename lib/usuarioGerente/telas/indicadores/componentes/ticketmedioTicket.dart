import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class TicketMediocontainer extends StatefulWidget {
  final double porcentagem;
  final double diferencaMeses;
  final double ticketValorMesSelecionado;
  final double ticketValorMesAnterior;
  final String mes;
  final String mesAnterior;
  const TicketMediocontainer({
    super.key,
    required this.porcentagem,
    required this.ticketValorMesSelecionado,
    required this.mes,
    required this.ticketValorMesAnterior,
    required this.diferencaMeses,
    required this.mesAnterior,
  });

  @override
  State<TicketMediocontainer> createState() => _TicketMediocontainerState();
}

class _TicketMediocontainerState extends State<TicketMediocontainer> {


  @override
  Widget build(BuildContext context) {
 
    return Container(
      // width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade100.withOpacity(0.7),
            Colors.grey.shade50,
            Colors.grey.shade100.withOpacity(0.8),
            Colors.grey.shade100.withOpacity(0.9),
            Colors.grey.shade200.withOpacity(0.9),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ticket",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Média de ${widget.mes}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
               widget.porcentagem >= 0? Icons.trending_up : Icons.trending_down,
                color: Dadosgeralapp().primaryColor,
                size: 15,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "R\$${widget.ticketValorMesSelecionado.toStringAsFixed(2).replaceAll('.', ',')}",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if(widget.porcentagem >=0)
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  "+${widget.porcentagem.toStringAsFixed(0)}%",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if(widget.porcentagem <0)
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  "${widget.porcentagem.toStringAsFixed(0)}%",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(widget.diferencaMeses >=0)
              Text(
                "+R\$${widget.diferencaMeses.toStringAsFixed(2).replaceAll('.', ',')} ",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if(widget.diferencaMeses <0)
               Text(
                "-R\$${widget.diferencaMeses.toStringAsFixed(2).replaceAll('.', ',').replaceAll('-', '')} ",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                "Comparado a ${widget.mesAnterior}",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
