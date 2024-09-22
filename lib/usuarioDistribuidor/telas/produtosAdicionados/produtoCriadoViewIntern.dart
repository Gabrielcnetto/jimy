import 'package:flutter/material.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioDistribuidor/classes/ProdutoShopping.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdutoCriadoViewIntern extends StatelessWidget {
  final ProdutoShopping produto;
  const ProdutoCriadoViewIntern({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 22,
                    color: Dadosgeralapp().primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      produto.nome,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: produto.urlImagensParaExibir.map((foto) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.48,
                            child: Image.network(
                              foto,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
