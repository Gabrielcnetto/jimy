import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/visaoAvancadaIndicadores/visaoComissao.dart';
import 'package:provider/provider.dart';

class InternoIndicadoresScreen extends StatefulWidget {
  const InternoIndicadoresScreen({super.key});

  @override
  State<InternoIndicadoresScreen> createState() =>
      _InternoIndicadoresScreenState();
}

class _InternoIndicadoresScreenState extends State<InternoIndicadoresScreen> {
  List<Barbeiros> _profissionais = [];
  int anoMesSelecionado = 2024;
  int anoMesAnteriorAoselecionado = 2024;
  String mesAnteriorDoSelecionado = "";
  String mesSelecionadoFinal = "";

  @override
  void initState() {
    super.initState();
    LoadTotal();
  }

  void LoadTotal() async {
    // Carrega os profissionais
    Provider.of<Getsdeinformacoes>(context, listen: false).getProfissionais;
    setState(() {
      _profissionais =
          Provider.of<Getsdeinformacoes>(context, listen: false).profList;
    });

    // Atualiza os meses e calcula as diferenças de faturamento
    String mesSelecionado = "Setembro"; // Exemplo
    await atualizarMes(mesSelecionado);
    calculoDiferencaFaturamento();
  }

  Future<void> atualizarMes(String mesSelecionado) async {
    // Lista dos meses em português
    List<String> meses = [
      "janeiro",
      "fevereiro",
      "março",
      "abril",
      "maio",
      "junho",
      "julho",
      "agosto",
      "setembro",
      "outubro",
      "novembro",
      "dezembro"
    ];

    // Encontrar o índice do mês selecionado
    int mesAtualIndex = meses.indexOf(mesSelecionado.toLowerCase());

    if (mesAtualIndex == -1) {
      print("Mês inválido!");
      return;
    }

    // Calcular o mês anterior
    int mesAnteriorIndex = (mesAtualIndex - 1) < 0 ? 11 : mesAtualIndex - 1;

    String mesAtual = meses[mesAtualIndex];
    String mesAnterior = meses[mesAnteriorIndex];

    setState(() {
      mesAnteriorDoSelecionado = mesAnterior;
      mesSelecionadoFinal = mesAtual;
    });

    await loadFaturamentoMesAtual();
    await loadFaturamentoMesAnterior();
  }

  double faturamentoMesAnterior = 0;
  double faturamentoMesAtual = 0;

  Future<void> loadFaturamentoMesAnterior() async {
    double? valor = await Getsdeinformacoes()
        .getFaturamentoMensalGerenteMesAnterior(
            anoDeBusca: anoMesAnteriorAoselecionado,
            mesAnterior: mesAnteriorDoSelecionado);

    setState(() {
      faturamentoMesAnterior = valor ?? 0;
      print("Faturamento mês anterior: $faturamentoMesAnterior");
    });
  }

  Future<void> loadFaturamentoMesAtual() async {
    double? valor = await Getsdeinformacoes()
        .getFaturamentoMensalGerenteMesSelecionado(
            anoDeBusca: anoMesSelecionado, mesSelecionado: mesSelecionadoFinal);

    setState(() {
      faturamentoMesAtual = valor ?? 0;
      print("Faturamento mês atual: $faturamentoMesAtual");
    });
  }
  double porcentagemFinal = 0;
  double diferencaFaturamento = 0;
  void calcularPercentualDiferenca(double valorAtual, double valorAnterior) {
    if (valorAnterior == 0) {
      // Evita divisão por zero, retornando 0% se o valor anterior for zero
     setState(() {
        porcentagemFinal = 0;
     });
    } 
    double valorFinal = ((valorAtual - valorAnterior) / valorAnterior) * 100;
    print("porcentagem Final faturamento:${valorFinal}");
    setState(() {
      porcentagemFinal = valorFinal;
    });
  }

  void calculoDiferencaFaturamento() {
    setState(() {
      diferencaFaturamento = faturamentoMesAtual - faturamentoMesAnterior;
    });

    // Calcula a porcentagem de diferença
    final percentualDiferenca = calcularPercentualDiferenca(
        faturamentoMesAtual, faturamentoMesAnterior);

    print('Diferença de faturamento: $diferencaFaturamento');
   
  }

  //get do mes atual(todas as informacoes) - fim
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
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
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Indicadores gerais",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            "Visão ampla e detalhada de seus indicadores",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        "Este mês",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Text(
                  "treste",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.paid,
                                size: 18,
                                color:
                                    Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Faturamento",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "R\$${faturamentoMesAtual.toStringAsFixed(2).replaceAll('.', ',')}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                      porcentagemFinal >= 0?  Icons.arrow_upward : Icons.arrow_downward,
                                        size: 12,
                                        color:porcentagemFinal >= 0? Colors.green.shade700 : Colors.red,
                                      ),
                                      if(porcentagemFinal >=0)
                                      Text(
                                        "${porcentagemFinal.toStringAsFixed(0)}%",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                       if(porcentagemFinal <0)
                                      Text(
                                        "${porcentagemFinal.toStringAsFixed(0)}%",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                       porcentagemFinal >=0 ? Colors.green.shade100.withOpacity(0.7) : Colors.red.shade100.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (diferencaFaturamento < 0)
                                Text(
                                  "-R\$${diferencaFaturamento.toStringAsFixed(2).replaceAll('.', ',').replaceAll('-', '')}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              if (diferencaFaturamento >= 0)
                                Text(
                                  "+R\$${diferencaFaturamento.toStringAsFixed(2).replaceAll('.', ',')}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              Text(
                                " vs ${mesAnteriorDoSelecionado}",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.shopping_cart_checkout,
                                size: 18,
                                color:
                                    Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Despesas",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "R\$5.000",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        size: 12,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "+5.7%",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "-R\$428,80",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Text(
                                " vs ${mesAnteriorDoSelecionado}",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Comissão dos profissionais",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            mesSelecionadoFinal.toUpperCase(),
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
                    ),
                    Column(
                      children: _profissionais.map((profissional) {
                        return ItemVisaoComissao(
                          mesDeBusca: mesSelecionadoFinal,
                          anoDeBusca: anoMesSelecionado,
                          barbeiro: profissional,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
