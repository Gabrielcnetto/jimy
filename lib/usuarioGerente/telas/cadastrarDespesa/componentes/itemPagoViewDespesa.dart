import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/classes/Despesa.dart';
import 'package:friotrim/usuarioGerente/telas/cadastrarDespesa/componentes/dentroDoComponenteJaPago.dart';
import 'package:friotrim/usuarioGerente/telas/cadastrarDespesa/dentroDaDespesaPendente.dart';

class itemVisualPagoListaGeralDespesa extends StatefulWidget {
  final Despesa despesa;
  const itemVisualPagoListaGeralDespesa({
    super.key,
    required this.despesa,
  });

  @override
  State<itemVisualPagoListaGeralDespesa> createState() =>
      _itemVisualPagoListaGeralDespesaState();
}

class _itemVisualPagoListaGeralDespesaState
    extends State<itemVisualPagoListaGeralDespesa> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDateList();
  }

  List<DateTime> _todosPagamentosHistorico = [];

  void setDateList() {
    setState(() {
      _todosPagamentosHistorico = widget.despesa.historicoPagamentos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => DentroDoComponenteJaPago(
                    despesaInfs: widget.despesa,
                  )));
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
                    "R\$${widget.despesa.preco.toStringAsFixed(2).replaceAll('.', ',')}",
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
                    widget.despesa.name,
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
                        "Data do pagamento: ${DateFormat("dd/MM/yyyy").format(_todosPagamentosHistorico[0])}",
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
                            color: Colors.green.shade100.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          "Pago",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w700,
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
                          widget.despesa.recorrente == true
                              ? "Recorrente"
                              : "Única",
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
