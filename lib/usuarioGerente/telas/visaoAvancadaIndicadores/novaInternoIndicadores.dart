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

class InternoIndicadoresScreenV2 extends StatefulWidget {
  const InternoIndicadoresScreenV2({super.key});

  @override
  State<InternoIndicadoresScreenV2> createState() =>
      _InternoIndicadoresScreenV2State();
}

class _InternoIndicadoresScreenV2State
    extends State<InternoIndicadoresScreenV2> {
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
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  //load e soma das despesas agora - fim
  List<Barbeiros> _profissionais = [];
  int anoMesSelecionado = 2024;
  int anoMesAnteriorAoselecionado = 2024;
  String mesAnteriorDoSelecionado = "";
  String mesSelecionadoFinal = "";
  void reloadTodososCalculos() {
    setState(() {
      atualizarMes(mesSelecionado: mesSelecionadoFinal);
      loadFaturamentoMesSelecionadoFN();
      loadTotaldespesas();
    });
  }

  double faturamentoMesSelecionado = 0;
  double faturamentoAnteriorAoMesSelecionado = 0;
  double diferencaFaturamento = 0;
  double porcentagemFaturamento = 0;
  Future<void> loadFaturamentoMesSelecionadoFN() async {
    double dbDataMesSelecionado =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .getFaturamentoMensalGerenteMesSelecionado(
      anoDeBusca: anoMesSelecionado,
      mesSelecionado: mesSelecionadoFinal,
    );

    double? dbDataMesAnterior =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .getFaturamentoMensalGerenteMesAnterior(
      anoDeBusca: anoMesAnteriorAoselecionado,
      mesAnterior: mesAnteriorDoSelecionado,
    );

    setState(() {
      faturamentoMesSelecionado = dbDataMesSelecionado;
      faturamentoAnteriorAoMesSelecionado = dbDataMesAnterior!;
      calculoDeDiferencaEntreOsFaturamentos(); // Calcula somente após os dois valores serem carregados
      calcularPorcentagemDeDiferenca();
    });
  }

  void calculoDeDiferencaEntreOsFaturamentos() {
    double valorCalculado =
        faturamentoMesSelecionado - faturamentoAnteriorAoMesSelecionado;
    setState(() {
      diferencaFaturamento = valorCalculado;
    });
    print('diferencaFaturamento: $diferencaFaturamento');
  }

  void calcularPorcentagemDeDiferenca() {
    if (faturamentoAnteriorAoMesSelecionado == 0 &&
        faturamentoMesSelecionado > 0) {
      // Caso especial: faturamento anterior foi 0, então o crescimento é 100%
      setState(() {
        porcentagemFaturamento = 100;
      });
      print('Porcentagem de diferença: 100% (crescimento total)');
    } else if (faturamentoAnteriorAoMesSelecionado != 0) {
      // Cálculo normal de porcentagem de diferença
      double diferenca =
          faturamentoMesSelecionado - faturamentoAnteriorAoMesSelecionado;
      double porcentagem =
          (diferenca / faturamentoAnteriorAoMesSelecionado) * 100;

      setState(() {
        porcentagemFaturamento = porcentagem;
      });
      print('Porcentagem de diferença: $porcentagemFaturamento%');
    } else {
      // Evitar divisão por zero e caso ambos os faturamentos sejam zero
      setState(() {
        porcentagemFaturamento = 0;
      });
      print('Porcentagem de diferença: 0% (sem crescimento)');
    }
  }

  double valorfinalDespesa = 0;
  double MesSelecionadoDespesa = 0;
  double mesAnteriorDespesa = 0;
  double valorRecorrente = 0;
  double porcentagemDespesa = 0;
  double diferencaDeDespesas = 0;
  DateTime dateMomento = DateTime.now();
  Future<void> loadTotaldespesas() async {
    print("acessei load das despesas");
    double? recorrente =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
                .getValorDeRecorrentesEsteMes() ??
            0.0;
    print("recorrente:${recorrente}");
    double? valorDespesaEsteMes =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
                .getDespesaMesSelecionado(
              anoDeBusca: anoMesSelecionado,
              mesSelecionado: mesSelecionadoFinal,
            ) ??
            0.0;

    print("valorDespesaEsteMes:${valorDespesaEsteMes}");
    double? valorDespesaMesAnterior =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
                .getDespesaMesAnterior(
              anoDeBusca: anoMesAnteriorAoselecionado,
              mesSelecionado: mesAnteriorDoSelecionado,
            ) ??
            0.0;
    print("valorDespesaMesAnterior:${valorDespesaMesAnterior}");
    String monthName = await DateFormat('MMMM', 'pt_BR').format(dateMomento);

    if (mesSelecionadoFinal == monthName) {
      setState(() {
        valorRecorrente = recorrente!;
        MesSelecionadoDespesa = valorDespesaEsteMes;
        mesAnteriorDespesa = valorDespesaMesAnterior;
        valorfinalDespesa = MesSelecionadoDespesa + valorRecorrente;
        calculoDeDiferencaEntreAsDespesas();
         calcularPorcentagemDeDiferencaDespesas();
      });
      print("MesSelecionadoDespesa:${MesSelecionadoDespesa}");
    } else {
      setState(() {
        MesSelecionadoDespesa = valorDespesaEsteMes;
        mesAnteriorDespesa = valorDespesaMesAnterior;
        valorfinalDespesa = MesSelecionadoDespesa;
        calculoDeDiferencaEntreAsDespesas();
        calcularPorcentagemDeDiferencaDespesas();
      });
    }
  }

  void calculoDeDiferencaEntreAsDespesas() {
    print("#2tu valorfinalDespesa:${valorfinalDespesa}");
    print("#2tu mesAnteriorDespesa:${mesAnteriorDespesa}");
    double valorCalculadoDespesas = valorfinalDespesa - mesAnteriorDespesa;
    setState(() {
      diferencaDeDespesas = valorCalculadoDespesas;
    });
    print("#hg: valorfinalDespesa:${valorfinalDespesa}");
    print("#hg: mesAnteriorDespesa:${mesAnteriorDespesa}");
    print('#hg: diferencaDespesa: $diferencaDeDespesas');
  }

  void calcularPorcentagemDeDiferencaDespesas() {
    if (mesAnteriorDespesa == 0 && valorfinalDespesa > 0) {
      // Caso especial: faturamento anterior foi 0, então o crescimento é 100%
      setState(() {
        porcentagemDespesa = 100;
      });
      print('Porcentagem de diferença: 100% (crescimento total)');
    } else if (mesAnteriorDespesa != 0) {
      // Cálculo normal de porcentagem de diferença
      double diferenca =
          valorfinalDespesa - mesAnteriorDespesa;
      double porcentagem =
          (diferenca / mesAnteriorDespesa) * 100;

      setState(() {
        porcentagemDespesa = porcentagem;
      });
      print('Porcentagem de diferença: $porcentagemDespesa%');
    } else {
      // Evitar divisão por zero e caso ambos os faturamentos sejam zero
      setState(() {
        porcentagemDespesa = 0;
      });
      print('Porcentagem de diferença: 0% (sem crescimento)');
    }
  }

  // Fim do load
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
          reloadTodososCalculos();
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
                                      "R\$${faturamentoMesSelecionado.toStringAsFixed(2).replaceAll('.', ',')}",
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
                                            porcentagemFaturamento >= 0
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward,
                                            size: 12,
                                            color: porcentagemFaturamento >= 0
                                                ? Colors.green.shade700
                                                : Colors.red,
                                          ),
                                          if (porcentagemFaturamento >= 0)
                                            Text(
                                              "${porcentagemFaturamento.toStringAsFixed(0)}%",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          if (porcentagemFaturamento < 0)
                                            Text(
                                              "${porcentagemFaturamento.toStringAsFixed(0)}%",
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
                                        color: porcentagemFaturamento >= 0
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
                                            porcentagemDespesa <= 0
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            size: 12,
                                            color: porcentagemDespesa <= 0
                                                ? Colors.green.shade700
                                                : Colors.red,
                                          ),
                                          Text(
                                            "${porcentagemDespesa.toStringAsFixed(0)}%",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: porcentagemDespesa <= 0
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
                                        color: porcentagemDespesa <= 0
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
