import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/classes/Despesa.dart';
import 'package:friotrim/usuarioGerente/telas/cadastrarDespesa/dentroDaDespesaPendente.dart';

class ItemVisualDespesa extends StatelessWidget {
  final Despesa despesa;
  const ItemVisualDespesa({
    super.key,
    required this.despesa,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>DentroDaDespesaPendente(despesaInfs: despesa,)));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "R\$${despesa.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    despesa.name,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Dia de vencimento: ${despesa.diaCobranca}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          "Pendente",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Dadosgeralapp().tertiaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          despesa.recorrente == true ? "Recorrente" : "Única",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.shopping_cart_checkout,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
