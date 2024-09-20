import 'package:flutter/material.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaDeCriarOProdutoDistribuidor extends StatefulWidget {
  const TelaDeCriarOProdutoDistribuidor({super.key});

  @override
  State<TelaDeCriarOProdutoDistribuidor> createState() =>
      _TelaDeCriarOProdutoDistribuidorState();
}

class _TelaDeCriarOProdutoDistribuidorState
    extends State<TelaDeCriarOProdutoDistribuidor> {
  bool venderparaGerentes = false;
  bool venderParaClientes = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        "Publicar Produto",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  //bool de para quem
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Informações Gerais:",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(54, 54, 54, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        venderparaGerentes =
                                            !venderparaGerentes;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            venderparaGerentes == true
                                                ? Colors.grey.shade50
                                                : Colors.transparent,
                                            venderparaGerentes == true
                                                ? Colors.grey.shade100
                                                    .withOpacity(0.6)
                                                : Colors.transparent,
                                            venderparaGerentes == true
                                                ? Colors.grey.shade100
                                                : Colors.transparent,
                                          ],
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: venderparaGerentes == true
                                              ? Colors.black
                                              : Colors.grey.shade100,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                venderparaGerentes == true
                                                    ? Icons.check_circle
                                                    : Icons
                                                        .radio_button_unchecked,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Para barbeiros",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Este item será exibido para os profissionais.",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        venderParaClientes =
                                            !venderParaClientes;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            venderParaClientes == true
                                                ? Colors.grey.shade50
                                                : Colors.transparent,
                                            venderParaClientes == true
                                                ? Colors.grey.shade100
                                                    .withOpacity(0.6)
                                                : Colors.transparent,
                                            venderParaClientes == true
                                                ? Colors.grey.shade100
                                                : Colors.transparent,
                                          ],
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: venderParaClientes == true
                                              ? Colors.black
                                              : Colors.grey.shade100,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                venderParaClientes == true
                                                    ? Icons.check_circle
                                                    : Icons
                                                        .radio_button_unchecked,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Clientes B2C",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Exibido para os Clientes das barbearias.",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome do Produto",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.grey.shade200,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
