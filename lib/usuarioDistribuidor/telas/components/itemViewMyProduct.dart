import 'package:flutter/material.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioDistribuidor/classes/ProdutoShopping.dart';
import 'package:Dimy/usuarioDistribuidor/telas/produtosAdicionados/produtoCriadoViewIntern.dart';
import 'package:google_fonts/google_fonts.dart';

class MYProducList extends StatelessWidget {
  final ProdutoShopping produto;
  const MYProducList({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                produto.urlImageFront,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              decoration: BoxDecoration(
                color: produto.usado == false
                    ? const Color.fromARGB(255, 3, 108, 195).withOpacity(0.2)
                    : Colors.orange.shade600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Adicione esta linha
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: produto.usado == false
                        ? const Color.fromARGB(255, 3, 108, 195)
                        : Colors.orange.shade600,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    produto.usado == false ? "Produto Novo" : "Produto Usado",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: produto.usado == false
                            ? Color.fromARGB(255, 3, 108, 195)
                            : Colors.orange.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              child: Text(
                produto.nome,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                maxLines: 1, // Limita o texto a uma linha
                overflow: TextOverflow
                    .ellipsis, // Trunca o texto com reticências (...)
                softWrap: false, // Impede a quebra de linha automática
              ),
            ),
          ),
          if (produto.precoParaBarbeiros != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                child: Text(
                  "R\$${produto.precoParaBarbeiros.toStringAsFixed(2).replaceAll('.', ',')}",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ProdutoCriadoViewIntern(
                    produto: produto,
                  ),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Dadosgeralapp().primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  "Editar",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Dadosgeralapp().primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
