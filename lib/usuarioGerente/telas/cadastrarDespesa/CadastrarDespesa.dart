import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/Despesa.dart';
import 'package:fiotrim/usuarioGerente/funcoes/despesas.dart';
import 'package:fiotrim/usuarioGerente/telas/cadastrarDespesa/componentes/itemVisualDespesa.dart';
import 'package:fiotrim/usuarioGerente/telas/cadastrarDespesa/componentes/listas/historicoCompletoDeSa%C3%ADdas.dart';
import 'package:fiotrim/usuarioGerente/telas/cadastrarDespesa/componentes/listas/historicoSaidasEsteMes.dart';
import 'package:fiotrim/usuarioGerente/telas/cadastrarDespesa/primeiraVisaoCadastro.dart';
import 'package:provider/provider.dart';

class cadastrarNovaDespesa extends StatefulWidget {
  const cadastrarNovaDespesa({super.key});

  @override
  State<cadastrarNovaDespesa> createState() => _cadastrarNovaDespesaState();
}

class _cadastrarNovaDespesaState extends State<cadastrarNovaDespesa> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMesAtual();
    Provider.of<DespesasFunctions>(context, listen: false).getDespesasLoad();
    Provider.of<DespesasFunctions>(context, listen: false)
        .getDespesasPosPagaLoad();
  }

  final nomeDespesaControler = TextEditingController();
  final precoProdutoControler = TextEditingController();
  int MesAtual = 0;
  void setMesAtual() {
    setState(() {
      MesAtual = DateTime.now().month;
    });
  }

  bool verHistoricoGeral = false;
  void setNewView() {
    setState(() {
      verHistoricoGeral = !verHistoricoGeral;
      Provider.of<DespesasFunctions>(context, listen: false).getDespesasLoad();
      Provider.of<DespesasFunctions>(context, listen: false)
          .getDespesasPosPagaLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                color: Colors.grey.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                            color: Dadosgeralapp().primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: setNewView,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: verHistoricoGeral == false ? 1 : 0,
                                  color: verHistoricoGeral == false
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                            child: Text(
                              "Saídas",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: verHistoricoGeral == false
                                      ? Colors.black
                                      : Colors.black45,
                                  fontSize:
                                      verHistoricoGeral == false ? 25 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: setNewView,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: verHistoricoGeral == true ? 1 : 0,
                                  color: verHistoricoGeral == true
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                            child: Text(
                              "Histórico",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: verHistoricoGeral == true
                                      ? Colors.black
                                      : Colors.black45,
                                  fontSize: verHistoricoGeral == true ? 25 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => PrimeiraVisaoCadastroBarbearia()));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Dadosgeralapp().primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Text(
                    "Adicionar saída",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.14,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.7,
                child: verHistoricoGeral == false
                    ? SaidasEsteMes(
                        mesAtual: MesAtual,
                      )
                    : HistoricoCompletoDeSaidas(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final number = double.tryParse(rawText) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    final formattedText = formatter.format(number / 100);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formattedText.length),
      ),
    );
  }
}
