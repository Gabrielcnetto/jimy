import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/telas/adicionarProdutos/viisaodetodososprodutos.dart';

class VisaoGeralMeusProdutosScreen extends StatefulWidget {
  const VisaoGeralMeusProdutosScreen({super.key});

  @override
  State<VisaoGeralMeusProdutosScreen> createState() =>
      _VisaoGeralMeusProdutosScreenState();
}

class _VisaoGeralMeusProdutosScreenState
    extends State<VisaoGeralMeusProdutosScreen> {
  bool todosOsProdutos = true;
  bool produtosVendidos = false;

  void ativarProdutosVendidos() {
    if (produtosVendidos == true) {
      return;
    }
    if (produtosVendidos == false) {
      setState(() {
        produtosVendidos = true;
        todosOsProdutos = false;
      });
    }
  }

  void ativarTodosOsProdutos() {
    if (todosOsProdutos == true) {
      return;
    }
    if (todosOsProdutos == false) {
      setState(() {
        todosOsProdutos = true;
        produtosVendidos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                    Text(
                      'Catálogo de produtos',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container() // Placeholder for alignment
                  ],
                ),
                SizedBox(height: 10),
                // Row das opções
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: ativarTodosOsProdutos,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Todos os Produtos",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: todosOsProdutos
                                  ? Colors.orangeAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: ativarProdutosVendidos,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Vendidos na Loja",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: produtosVendidos
                                  ? Colors.orangeAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //parte de ver as informações
          Expanded(
            child: SingleChildScrollView(
              child: todosOsProdutos
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: VisaoDeTodosOsProdutos(),
                    )
                  : Container(), // Placeholder for other content
            ),
          ),
        ],
      ),
    );
  }
}
