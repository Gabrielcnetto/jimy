import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/Despesa.dart';
import 'package:jimy/usuarioGerente/funcoes/despesas.dart';
import 'package:jimy/usuarioGerente/telas/cadastrarDespesa/componentes/itemVisualDespesa.dart';
import 'package:jimy/usuarioGerente/telas/cadastrarDespesa/primeiraVisaoCadastro.dart';
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
  }

  final nomeDespesaControler = TextEditingController();
  final precoProdutoControler = TextEditingController();
  int MesAtual = 0;
  void setMesAtual() {
    setState(() {
      MesAtual = DateTime.now().month;
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
                    Container(
                      child: Text(
                        "Saídas",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                child: StreamBuilder(
                  stream: Provider.of<DespesasFunctions>(context, listen: false)
                      .getDespesaList,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Dadosgeralapp().primaryColor,
                        ),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "Nenhuma Despesa criada",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      List<Despesa> listaDespesa =
                          snapshot.data as List<Despesa>;
                      List<Despesa> listaDespesaFiltrada = listaDespesa
                          .where((atributo) => atributo.pagoDeInicio == false && atributo.momentoFinalizacao.month != MesAtual)
                          .toList();
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listaDespesaFiltrada.map(
                            (item) {
                              return ItemVisualDespesa(
                                despesa: item,
                              );
                            },
                          ).toList(),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
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
