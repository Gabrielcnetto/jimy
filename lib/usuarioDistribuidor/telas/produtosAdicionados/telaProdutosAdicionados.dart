import 'package:flutter/material.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioDistribuidor/telas/produtosAdicionados/componentes/listaEBotaoVenderAgora.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaProdutosAdicionados extends StatelessWidget {
  const TelaProdutosAdicionados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.15,
            child: ListEBotaoVenderAgora(),
          ),
          Positioned(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                color: Dadosgeralapp().primaryColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seu Catálogo",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            40,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            top: 0,
            right: 0,
            left: 0,
          ),
        ],
      ),
    );
  }
}
