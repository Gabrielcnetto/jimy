import 'package:flutter/material.dart';
import 'package:Dimy/usuarioGerente/UsuarioGerenteHome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/telas/visaoAvancadaIndicadores/novaInternoIndicadores.dart';

class IndicadoresQuadroViewFuncionario extends StatefulWidget {
  const IndicadoresQuadroViewFuncionario({super.key});

  @override
  State<IndicadoresQuadroViewFuncionario> createState() =>
      _IndicadoresQuadroViewFuncionarioState();
}

class _IndicadoresQuadroViewFuncionarioState
    extends State<IndicadoresQuadroViewFuncionario> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadminhaComissaoMensal();
    
     loadTotalclientes();
  }

 

  double minhaComissao = 0;

  Future<void> loadminhaComissaoMensal() async {
    double? valor =
        await Getsdeinformacoes().getComissaoDoBarbeiroVisaoFuncionario();

    setState(() {
      minhaComissao = valor!;
    });
  }

  int totalClientes = 0;
  Future<void> loadTotalclientes() async {
    int? valor = await Getsdeinformacoes().getQuantiaClientesMesFuncionario();

    setState(() {
      totalClientes = valor!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Indicadores",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 25,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "R\$${minhaComissao.toStringAsFixed(2).replaceAll('.', ',')}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Comissão Total",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.groups,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${totalClientes} Clientes",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Atendidos no mês",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
