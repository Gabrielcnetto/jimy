import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/rotas/AppRoutes.dart';

class ConfirmacaoAgendamento extends StatelessWidget {
  const ConfirmacaoAgendamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              child: Image.asset(
                "imagesapp/confirmAgend.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              color: Colors.black54.withOpacity(0.8),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Agendamento Concluído!",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.center,
                      child: Text(
                        "Seu agendamento foi feito com sucesso e já está incluso na agenda do profissional.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacementNamed(Approutes.VerificacaoDeLogado);
                      },
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Dadosgeralapp().primaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Acessar Página inicial",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
