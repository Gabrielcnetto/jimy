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
    String mesSelecionado = mesSelecionadoFinal; // Exemplo
    setState(() {
      atualizarMes(mesSelecionado: mesSelecionado);
    });
    calculoDiferencaFaturamento();
    loadValorRecorrentes();
    loadDespesasTotal();
    calculoDiferencaFaturamento();
  }

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
  void reloadAllFunctions() async {
    setState(() {
      _profissionais = [];
      isLoading = true;
    });
    await loadFaturamentoMesAtual();
    await loadFaturamentoMesAnterior();
    setState(() {
      atualizarMes(mesSelecionado: mesSelecionadoFinal);
    });
    await loadDespesasTotal();
    await calculardespesaCorretamenteAposMesSelecionado();
    await calculoDiferente();
    setState(() {
      _profissionais =
          Provider.of<Getsdeinformacoes>(context, listen: false).profList;
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> atualizarMes({required String mesSelecionado}) async {
    // Lista dos meses em português

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
      calculoDiferencaFaturamento();
    });
  }

  Future<void> loadFaturamentoMesAtual() async {
    double? valor = await Getsdeinformacoes()
        .getFaturamentoMensalGerenteMesSelecionado(
            anoDeBusca: anoMesSelecionado, mesSelecionado: mesSelecionadoFinal);

    setState(() {
      faturamentoMesAtual = valor ?? 0;
      print("Faturamento mês atual: $faturamentoMesAtual");
      calculoDiferencaFaturamento();
    });
  }

  double porcentagemFinal = 0;
  double diferencaFaturamento = 0;

  void calcularPercentualDiferenca(double valorAtual, double valorAnterior) {
    if (valorAnterior == 0) {
      setState(() {
        porcentagemFinal = valorAtual > 0
            ? 100
            : 0; // Se o valor atual for positivo, 100%. Se for 0, 0%.
      });
    } else {
      double valorFinal = ((valorAtual - valorAnterior) / valorAnterior) * 100;
      print("Porcentagem final faturamento: $valorFinal");
      setState(() {
        porcentagemFinal = valorFinal;
      });
    }
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

  //load e soma das despesas agora - inicio
  //se o mes atual for o selecionado somamos as despesas  recorrentes(valor junto)
  double valorfinalDespesa = 0;
  double valorRecorrentes = 0;
  double despesaMesAnteriorAoSelecionado = 0;
  double diferencaDeDespesas = 0;
  double valorDespesaMesSelecionado = 0;
  loadDespesasTotal() async {
    loadValorRecorrentes();
    loadDespesaMesPassado();
    calculardespesaCorretamenteAposMesSelecionado();
    print("diferencaDeDespesas:${diferencaDeDespesas}");
  }

  Future<void> loadValorRecorrentes() async {
    double? valor = await Getsdeinformacoes().getValorDeRecorrentesEsteMes();

    setState(() {
      valorRecorrentes = valor ?? 0;
      calculardespesaCorretamenteAposMesSelecionado();
    });
  }

  Future<void> loadValorDespesaMesSelecionado() async {
    double? valor = await Getsdeinformacoes().getDespesaMesSelecionado(
      anoDeBusca: anoMesSelecionado,
      mesSelecionado: mesSelecionadoFinal,
    );

    setState(() {
      valorDespesaMesSelecionado = valor ?? 0;
      calculardespesaCorretamenteAposMesSelecionado();
    });
  }

  Future<void> loadDespesaMesPassado() async {
    double? valor = await Getsdeinformacoes().getDespesaMesAnterior(
        anoDeBusca: anoMesAnteriorAoselecionado,
        mesSelecionado: mesAnteriorDoSelecionado);

    setState(() {
      despesaMesAnteriorAoSelecionado = valor ?? 0;
      calculardespesaCorretamenteAposMesSelecionado();
      calcularPercentualDiferencaDespesa(
          valorAnterior: despesaMesAnteriorAoSelecionado,
          valorAtual: valorfinalDespesa);
    });
  }
   calculoDiferente(){
    setState(() {
      diferencaDeDespesas =
            valorfinalDespesa - despesaMesAnteriorAoSelecionado;
    });
  }
  DateTime momentoAtual = DateTime.now();
   calculardespesaCorretamenteAposMesSelecionado() async {
    String mesAtual = DateFormat('MMMM', 'pt_BR').format(momentoAtual);
    if (mesSelecionadoFinal == mesAtual) {
      setState(() {
        valorfinalDespesa = valorRecorrentes;
        calculoDiferente();
      });
    } else {
      await loadValorDespesaMesSelecionado();
      setState(() {
        valorfinalDespesa = valorDespesaMesSelecionado;
      });
    }
  }

  double porcentagemFinalDespesa = 0;
  void calcularPercentualDiferencaDespesa(
      {required double valorAtual, required double valorAnterior}) {
    if (valorAnterior == 0) {
      // Evita divisão por zero e define a porcentagem de acordo com o valor atual
      setState(() {
        porcentagemFinalDespesa = valorAtual > 0 ? 100 : 0;
      });
    } else {
      double valorFinal = ((valorAtual - valorAnterior) / valorAnterior) * 100;
      print("Porcentagem final despesa: $valorFinal");
      setState(() {
        porcentagemFinalDespesa = valorFinal;
      });
    }
  }

  //load e soma das despesas agora - fim
  void _mostrarMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromRect(
        position & Size(40, 40), // Posição e tamanho do botão "Este mês"
        Offset.zero & overlay.size, // Área total da tela
      ),
      items: meses.map((mes) {
        return PopupMenuItem<String>(
          value: mes,
          child: Text(
            mes,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    ).then((String? mesSelecionado) {
      if (mesSelecionado != null) {
        setState(() {
          mesSelecionadoFinal = mesSelecionado;
          reloadAllFunctions();
        });
        print('Mês selecionado: $mesSelecionado');
      }
    });
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                        GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _mostrarMenu(context, details.globalPosition);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Text(
                              "${mesSelecionadoFinal}",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
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
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            porcentagemFinal >= 0
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            size: 12,
                                            color: porcentagemFinal >= 0
                                                ? Colors.green.shade700
                                                : Colors.red,
                                          ),
                                          if (porcentagemFinal >= 0)
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
                                          if (porcentagemFinal < 0)
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
                                        color: porcentagemFinal >= 0
                                            ? Colors.green.shade100
                                                .withOpacity(0.7)
                                            : Colors.red.shade100
                                                .withOpacity(0.5),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
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
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "R\$${valorfinalDespesa.toStringAsFixed(2).replaceAll('.', ',')}",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            porcentagemFinalDespesa <= 0
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            size: 12,
                                            color: porcentagemFinalDespesa <= 0
                                                ? Colors.green.shade700
                                                : Colors.red,
                                          ),
                                          Text(
                                            "${porcentagemFinalDespesa.toStringAsFixed(0)}%",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color:
                                                    porcentagemFinalDespesa <= 0
                                                        ? Colors.green.shade700
                                                        : Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: porcentagemFinalDespesa <= 0
                                            ? Colors.green.shade100
                                                .withOpacity(0.7)
                                            : Colors.red.shade100
                                                .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (diferencaDeDespesas > 0)
                                    Text(
                                      "+R\$${diferencaDeDespesas.toStringAsFixed(2).replaceAll('.', ',').replaceAll('-', '')}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  if (diferencaDeDespesas <= 0)
                                    Text(
                                      "-R\$${diferencaDeDespesas.toStringAsFixed(2).replaceAll('.', ',').replaceAll('-', '')}",
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
          if (isLoading) // Exibe o CircularProgressIndicator quando isLoading for true
            Container(
              color: Colors.black.withOpacity(0.5), // Fundo semitransparente
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Dadosgeralapp().primaryColor, // Cor do indicador
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
