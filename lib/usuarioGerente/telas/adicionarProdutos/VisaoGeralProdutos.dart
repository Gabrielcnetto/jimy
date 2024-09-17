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
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      'Produtos cadastrados',
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
              
                // Row das opções
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          //parte de ver as informações
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: VisaoDeTodosOsProdutos(),
              ), // Placeholder for other content
            ),
          ),
        ],
      ),
    );
  }
}
