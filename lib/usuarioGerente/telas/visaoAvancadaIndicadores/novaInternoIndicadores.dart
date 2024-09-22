import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/barbeiros.dart';
import 'package:fiotrim/usuarioGerente/classes/produto.dart';
import 'package:fiotrim/usuarioGerente/classes/servico.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/grafico.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/ticketmedioTicket.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/ListaComTodosOsClientes.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/graficoIndicadorPrincipal.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/itemProdutoView.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/telaClientesMesSelecionado.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/visaoComissao.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/visaoServicosEscolhidos.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/visaoTodososServicos.dart';
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

  int totalClientesMesSelecionado = 0;
  Future<void> loadTotalclientes(
      {required String mesSelecionado, required int Ano}) async {
    int? valor = await Getsdeinformacoes().getTotalClientesMesSelecionado(
        anoSelecionado: Ano, mesSelecionado: mesSelecionado);

    setState(() {
      totalClientesMesSelecionado = valor!;
    });
  }

  int totalClientesTotalComOApp = 0;
  Future<void> loadTotalclientesHistorico() async {
    int? valor = await Getsdeinformacoes().getTotaldeClientesTotalComandas();
    setState(() {
      totalClientesTotalComOApp = valor!;
    });
  }

  double ticketMesSelecionado = 0.0;
  Future<void> getTotalTicket(
      {required String mesSelecionado,
      required int anoDoMesSelecionado}) async {
    print("madasdasdsaeis:}");
    double? dbMesSelecionado =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .calculoTicketMedioMesSelecionado(
      ano: anoDoMesSelecionado,
      mes: mesSelecionado,
    );
    setState(() {
      ticketMesSelecionado = dbMesSelecionado!;
    });
  }

  double ticketMesSelecionadoAnterior = 0.0;
  Future<void> getTotalTicketAnterior(
      {required String mesSelecionadoAnterior,
      required int anoDoMesSelecionadoAnterior}) async {
    double? dbMesSelecionado =
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .calculoTicketMedioMesAnterior(
      ano: anoDoMesSelecionadoAnterior,
      mes: mesSelecionadoAnterior,
    );
    setState(() {
      ticketMesSelecionadoAnterior = dbMesSelecionado!;
    });
  }

  double valorDiferencaTickets = 0.0;
  calcDiferencaTicket() {
    setState(() {
      valorDiferencaTickets =
          ticketMesSelecionado - ticketMesSelecionadoAnterior;
    });
  }

  double porcentagemfinalTicket = 0.0;
  void calcularPorcentagemDeDiferencaTicket() {
    if (ticketMesSelecionadoAnterior != 0) {
      setState(() {
        porcentagemfinalTicket =
            ((ticketMesSelecionado - ticketMesSelecionadoAnterior) /
                    ticketMesSelecionadoAnterior) *
                100;
      });
    } else {
      setState(() {
        porcentagemfinalTicket = 0;
      }); // Evita divisão por zero se o valor anterior for 0
    }
  }

  void LoadTotal() async {
    // Carrega os profissionais

    DateTime datetimeAtual = DateTime.now();
    String monthName = await DateFormat('MMMM', 'pt_BR').format(datetimeAtual);
    await Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaServicos();
    setState(() {
      mesSelecionadoFinal = monthName.toLowerCase();
      _profissionais =
          Provider.of<Getsdeinformacoes>(context, listen: false).profList;
      reloadTodososCalculos();
    });
    Provider.of<CriarEEnviarprodutos>(context, listen: false)
        .LoadProductsBarbearia();
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

  void reloadTodososCalculos() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      _profissionais = []; // Limpa a lista antes de recarregar
    });
    await Future.delayed(Duration(milliseconds: 100));
    setState(() async {
      atualizarMes(mesSelecionado: mesSelecionadoFinal);
      loadFaturamentoMesSelecionadoFN(mesSelecionadoFinal);
      loadTotaldespesas();
      _profissionais =
          Provider.of<Getsdeinformacoes>(context, listen: false).profList;
      isLoading = false;
    });
  }

  double faturamentoMesSelecionado = 0;
  double faturamentoAnteriorAoMesSelecionado = 0;
  double diferencaFaturamento = 0;
  double porcentagemFaturamento = 0;
  String mesAnteriorDoSelecionado = "";
  String mesSelecionadoFinal = "";
  double ticketMesAtual = 0.0;
  double ticketMesAnterior = 0.0;
  double porcentagemTicketfinal = 0.0;
  Future<void> loadFaturamentoMesSelecionadoFN(
      String mesSelecionadoNome) async {
    final List<String> meses = [
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

    DateTime agora = DateTime.now();
    DateFormat formatter = DateFormat('MMMM', 'pt_BR');

    // Pega o mês selecionado
    DateTime mesSelecionadoDate = formatter.parse(mesSelecionadoNome, true);
    int mesSelecionado = mesSelecionadoDate.month;
    int anoSelecionado = agora.year;

    // Ajusta o ano se o mês selecionado já passou este ano
    if (mesSelecionado > agora.month) {
      anoSelecionado = agora.year - 1;
    }

    // Definir o mês e ano para as variáveis globais
    mesSelecionadoFinal = mesSelecionadoNome;
    anoMesSelecionado = anoSelecionado;

    // Calcula o mês anterior
    int mesAnterior = mesSelecionado - 1;
    int anoMesAnterior = anoSelecionado;

    // Se o mês anterior for 0, ajusta para dezembro do ano anterior
    if (mesAnterior == 0) {
      mesAnterior = 12;
      anoMesAnterior -= 1;
    }

    // Ajusta o nome do mês anterior usando a lista de meses
    mesAnteriorDoSelecionado = meses[mesAnterior - 1];
    anoMesAnteriorAoselecionado = anoMesAnterior;

    getTotalTicket(
      anoDoMesSelecionado: anoSelecionado,
      mesSelecionado: mesSelecionadoFinal,
    );
    getTotalTicketAnterior(
        mesSelecionadoAnterior: mesAnteriorDoSelecionado,
        anoDoMesSelecionadoAnterior: anoMesAnterior);
    loadTotalclientes(
      Ano: anoSelecionado,
      mesSelecionado: mesSelecionadoFinal,
    );
    loadTotalclientesHistorico();
    // Carregar os dados de faturamento
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

    // Atualizar o estado após carregar os dados
    setState(() {
      faturamentoMesSelecionado = dbDataMesSelecionado;
      faturamentoAnteriorAoMesSelecionado = dbDataMesAnterior!;
      calcDiferencaTicket();
      calcularPorcentagemDeDiferencaTicket();
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
      double diferenca = valorfinalDespesa - mesAnteriorDespesa;
      double porcentagem = (diferenca / mesAnteriorDespesa) * 100;

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
          _profissionais = [];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seus Indicadores Gerais",
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
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                "Visão ampla e detalhada de seus indicadores",
                                textAlign: TextAlign.left,
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: GraficosPage(
                      date: DateTime.now(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selecione o mês:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Text(
                      "Ticket Médio",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.black,
                            ),
                            Text(
                              " ${mesSelecionadoFinal.toUpperCase()} ",
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
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TicketMediocontainer(
                            porcentagem: porcentagemfinalTicket,
                            diferencaMeses: valorDiferencaTickets,
                            ticketValorMesAnterior:
                                ticketMesSelecionadoAnterior,
                            ticketValorMesSelecionado: ticketMesSelecionado,
                            mesAnterior: mesAnteriorDoSelecionado,
                            mes: mesSelecionadoFinal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Text(
                      "Produtos mais vendidos",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: StreamBuilder(
                      stream: Provider.of<CriarEEnviarprodutos>(context,
                              listen: false)
                          .ProdutosAvendaStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Dadosgeralapp().primaryColor,
                            ),
                          );
                        }
                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "Sem produtos criados ou vendidos",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          final List<Produtosavenda>? produtosLista =
                              snapshot.data;
                          produtosLista!.sort((a, b) =>
                              b.quantiavendida.compareTo(a.quantiavendida));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Painel de vendas ",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "- soma total*",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: produtosLista!.map((item) {
                                  return ItensVendidos(
                                    produtos: item,
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Serviços mais escolhidos",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => TodosOsServicos()));
                          },
                          child: Text(
                            "Ver todos",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: StreamBuilder(
                      stream:
                          Provider.of<Getsdeinformacoes>(context, listen: true)
                              .getServiceList,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Dadosgeralapp().primaryColor,
                            ),
                          );
                        }
                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              "Sem Serviços",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          List<Servico> listaServico =
                              snapshot.data as List<Servico>;
                          listaServico.sort((a, b) =>
                              b.quantiaEscolhida.compareTo(a.quantiaEscolhida));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Frequência de Escolha ",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "- Soma total*",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: listaServico.map((servico) {
                                  return VisaoServicosEscolhidos(
                                    servico: servico,
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Text(
                      "Clientes atendidos",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.groups,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Cadastros Feitos na ${Dadosgeralapp().nomeSistema}",
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
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Clientes em ${mesSelecionadoFinal}",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Serviços finalizados*",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${totalClientesMesSelecionado} Clientes",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                TelaClientesMesSelecionado(
                                              mesSelecionado:
                                                  mesSelecionadoFinal,
                                              AnoSelecionado: anoMesSelecionado,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Dadosgeralapp().primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ver clientes",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            Container(
                                              child: Icon(
                                                Icons.arrow_right_alt,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                      ),
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
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total de clientes no sistema",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Todos os seus clientes",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${totalClientesTotalComOApp} Cadastros",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Dadosgeralapp().primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Em breve*",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
