import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';

class ComandaScreen extends StatefulWidget {
  final Corteclass corte;
  const ComandaScreen({
    super.key,
    required this.corte,
  });

  @override
  State<ComandaScreen> createState() => _ComandaScreenState();
}

class _ComandaScreenState extends State<ComandaScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadInicialInfs();
  }

  void LoadInicialInfs() {
    setPreValorInicial();
  }

  //
  double valorServicosAdicionados = 0;
  double valorProdutosAdicionados = 0;
  double valorFinalTotal = 0;
  void setPreValorInicial() {
    setState(() {
      valorFinalTotal = widget.corte.valorCorte;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 15,
              right: 0,
              child: Container(
                width: double.infinity,
                child: Text(
                  "Pré-Finalização",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.width * 0.26,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.95,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.network(
                                      widget.corte.urlImagePerfilfoto,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${widget.corte.clienteNome}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "+${widget.corte.pontosGanhos} pontos",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Dadosgeralapp().primaryColor,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Serviços feitos:",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15)),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "- ${widget.corte.nomeServicoSelecionado}",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${widget.corte.valorCorte.toStringAsFixed(2).replaceAll('.', ',')}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.green.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 15),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.8, color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //valor produtos - inicio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adicional de Produtos:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "R\$${valorProdutosAdicionados.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //valor produtos - fim
                    SizedBox(
                      height: 15,
                    ),
                    //valor servicos - inicio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adicional de Serviços:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "R\$${valorServicosAdicionados.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //valor servicos - fim
                    SizedBox(
                      height: 15,
                    ),
                    //valor total - inicio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Custo total:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "R\$${valorFinalTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //valor total - fim
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Dadosgeralapp().tertiaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Finalizar agora",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                height: MediaQuery.of(context).size.height * 0.08,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
