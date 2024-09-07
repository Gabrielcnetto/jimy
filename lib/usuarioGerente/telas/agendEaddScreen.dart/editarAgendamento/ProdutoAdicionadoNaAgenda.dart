import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/usuarioGerente/classes/produto.dart';

class ProdutoAdicionadoNaComanda extends StatelessWidget {
  final Produtosavenda produto;
  const ProdutoAdicionadoNaComanda({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "- ${produto.nome}",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              "R\$${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}",
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
      ),
    );
  }
}
