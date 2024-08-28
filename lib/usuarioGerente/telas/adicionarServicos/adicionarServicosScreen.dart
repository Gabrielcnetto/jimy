import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/funcoes/CriarServicos.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class AdicionarServicosScreen extends StatefulWidget {
  const AdicionarServicosScreen({super.key});

  @override
  State<AdicionarServicosScreen> createState() =>
      _AdicionarServicosScreenState();
}

class _AdicionarServicosScreenState extends State<AdicionarServicosScreen> {
  final nomeServicoControler = TextEditingController();
  final precoProdutoControler = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _forms = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadloadIdBarbearia();
  }

  String? loadIdBarbearia;

  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  bool isLoading = false;
  Future<void> configurarServico() async {
    try {
      setState(() {
        isLoading = true;
      });
      String valorFormatado =
          precoProdutoControler.text.replaceAll("R\$", "").trim();
      valorFormatado = valorFormatado.replaceAll(",", ".");
      double valorDouble = double.parse(valorFormatado);
      await Provider.of<Criarservicos>(context, listen: false).addServico(
        serviceName: nomeServicoControler.text,
        servicePrice: valorDouble,
        tempoParaFazer: 30,
        idBarbearia: loadIdBarbearia!,
      );
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        barrierDismissible:
            false, // Evita que o diálogo seja fechado ao tocar fora dele
        builder: (ctx) {
          // Inicia um Timer para fechar o diálogo e redirecionar após 3 segundos
          Timer(Duration(seconds: 3), () {
            Navigator.of(ctx).pop(); // Fecha o diálogo
            Navigator.of(ctx).pop();
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Serviço criado",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ),
            content: Text(
              "Aguarde um instante...",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black45),
              ),
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Dados incorretos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              content: Text(
                "Verifique os dados inseridos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Fechar",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      print("houve um erro: $e");
    }
  }

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
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _forms,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Text(
                            "Cadastrar Serviços",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          child: Text(
                            "Detalhe os cortes e procedimentos feitos em sua barbearia. Corte, barba, barba express...\n\nRecomendamos colocar até 5 serviços para melhor conversão dos clientes.",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Informações do serviço:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nome do Serviço",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.barcode_reader,
                                    size: 20,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite um nome';
                                        }
                                        return null;
                                      },
                                      controller: nomeServicoControler,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        //fim nome
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preço",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.7,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite um Preço';
                                    }
                                    return null;
                                  },
                                  controller: precoProdutoControler,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                    // Custom formatter to ensure currency format is applied
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Clique para Digitar(R\$)",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        
                        InkWell(
                          onTap: () {
                            if (_forms.currentState!.validate()) {
                              configurarServico();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Dadosgeralapp().primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Adicionar Serviço",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading == true) ...[
                Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
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
