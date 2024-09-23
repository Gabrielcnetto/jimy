import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/funcoes/configurarPontos.dart';
import 'package:provider/provider.dart';

class TelaTrocadePontos extends StatefulWidget {
  const TelaTrocadePontos({super.key});

  @override
  State<TelaTrocadePontos> createState() => _TelaTrocadePontosState();
}

class _TelaTrocadePontosState extends State<TelaTrocadePontos> {

  
  final QuantiaEmPontosControler = TextEditingController();
  double quantiaConvertida = 0; // Quantia em pontos ou reais
  bool isReais = true; // Define se o valor atual é em reais

  @override
  void initState() {
    super.initState();
    loadPontosPreConfigurados();
    // Adiciona um listener ao controlador para atualizar a quantia em pontos automaticamente
    QuantiaEmPontosControler.addListener(_atualizarQuantia);
  }

  @override
  void dispose() {
    // Remove o listener quando o widget for descartado
    QuantiaEmPontosControler.removeListener(_atualizarQuantia);
    QuantiaEmPontosControler.dispose();
    super.dispose();
  }

  Future<void>loadPontosPreConfigurados()async{
    int? getDB = await Provider.of<Getsdeinformacoes>(context,listen: false).getPontosMinimosClientes() ??0;
    setState(() {
      QuantiaEmPontosControler.text = getDB.toString() ;
    });
  }
  void _atualizarQuantia() {
    // Obtém o valor a partir do controlador
    double quantia = double.tryParse(QuantiaEmPontosControler.text) ?? 0.0;

    // Atualiza o estado com base no tipo de valor (reais ou pontos)
    setState(() {
      if (isReais) {
        // Converte reais para pontos
        quantiaConvertida = converterParaPontos(quantia);
      } else {
        // Converte pontos para reais
        quantiaConvertida = converterParaReais(quantia);
      }
    });
  }

  double converterParaPontos(double quantiaEmReais) {
    // Calcula a quantia em pontos a partir dos reais
    return quantiaEmReais / 10.0;
  }

  double converterParaReais(double quantiaEmPontos) {
    // Calcula a quantia em reais a partir dos pontos
    return quantiaEmPontos * 10.0;
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> atualizarPontos() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Configurarpontos>(context, listen: false).sentPoints(
          TotalPontos: int.parse(
        QuantiaEmPontosControler.text,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("ao atualizar pontuacao no widget deu isso:$e");
    }
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                              color: Dadosgeralapp().primaryColor,
                            ),
                          ),
                          Text(
                            "Configurar Troca de pontos",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset(
                          "imagesapp/pointsBanner.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${QuantiaEmPontosControler.text }",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Pontos para trocar em serviços",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Converta abaixo os pontos e atualize para a quantia que você desejar.",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "A Cada serviço que o cliente faz, ele acumulara pontos de acordo com o valor gasto na barbearia em serviços. Ao acumular a quantia determinada abaixo ele poderá trocar por um serviço grátis equivalente aos pontos",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      "R\$1,00 = 10 Pontos",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color:
                                                Dadosgeralapp().tertiaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantia de pontos:",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Dadosgeralapp().tertiaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Quantia em pontos",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    QuantiaEmPontosControler,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                validator: (value) {
                                                  // Verifica se o valor é um número e é maior que 1500
                                                  final number =
                                                      double.tryParse(
                                                          value ?? '');
                                                  if (number == null ||
                                                      number < 1700) {
                                                    return 'Mínimo 1700';
                                                  }
                                                  return null; // Retorna null se a validação passar
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Dadosgeralapp().tertiaryColor,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Convertido em R\$",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "R\$${quantiaConvertida.toStringAsFixed(2).replaceAll('.', ',')}",
                                            ),
                                          ],
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Observação: O Cliente só recebe os pontos após você finalizar a comanda do corte.",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "X - Esta opção não pode ser desabilitada *",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              atualizarPontos();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Dadosgeralapp().primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Atualizar Valor",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading == true) ...[
                  Opacity(
                    opacity: 0.5,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
