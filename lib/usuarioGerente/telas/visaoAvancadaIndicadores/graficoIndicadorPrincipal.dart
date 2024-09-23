import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/grafico.dart';
import 'package:Dimy/usuarioGerente/telas/visaoAvancadaIndicadores/fundoPontilhado.dart';
import 'package:provider/provider.dart';

class GraficosPage extends StatefulWidget {
  final DateTime date;

  const GraficosPage({
    super.key,
    required this.date,
  });
  @override
  _GraficosPageState createState() => _GraficosPageState();
}

class _GraficosPageState extends State<GraficosPage> {
  bool isLoading = false;

  void mesSet() async {

    setState(() {
      isLoading = true;
    });
    setState(() {
      mesAtual = DateFormat('MMMM', 'pt_BR').format(widget.date);
    });
    setState(() {
      isLoading = false;
    });
    
  }

  final ScrollController _scrollController = ScrollController();
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
  String mesAtual = "";
  List<String> ordenarMeses() {
    final agora = DateTime.now();
    final mesAtual = DateFormat('MMMM', 'pt_BR').format(agora).toLowerCase();
    final mesAtualIndex = meses.indexOf(mesAtual);

    // Obter o próximo mês, tratando o caso de dezembro
    final proximoMesIndex = (mesAtualIndex + 1) % 12;
    final proximoMes = meses[proximoMesIndex];

    // Ordenar a lista
    final listaOrdenada = [
      ...meses.sublist(proximoMesIndex),
      ...meses.sublist(0, proximoMesIndex),
    ];

    // Colocar o mês atual no final
    final resultado = listaOrdenada.where((mes) => mes != mesAtual).toList();
    resultado.add(mesAtual);

    return resultado;
  }

  double maiorLucro = 0;

  bool okForLoad = false;
  bool okForExibir = true;
  void getBoolFilho(bool bool) {
    setState(() {
      okForExibir = bool;
    });
  }

  Future<void> calcPercentage() async {
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

    for (String mes in meses) {
      // Formata e analisa o mês selecionado
      DateTime mesSelecionadoDate = formatter.parse(mes, true);
      int mesSelecionado = mesSelecionadoDate.month;
      int anoSelecionado = agora.year;

      // Ajusta o ano se o mês selecionado for maior que o mês atual
      if (mesSelecionado > agora.month) {
        anoSelecionado = agora.year - 1;
      }

      // Obtém os valores necessários
      double faturamento =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getFaturamentoMensalGerenteMesSelecionado(
                anoDeBusca: anoSelecionado,
                mesSelecionado: mes,
              ) ??
              0.0;
      double comissao =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getComissaoTotalMensalGerenteMes(
                ano: anoSelecionado,
                mes: mes,
              ) ??
              0.0;
      double despesas =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getDespesaMesSelecionado(
                anoDeBusca: anoSelecionado,
                mesSelecionado: mes,
              ) ??
              0.0;

      // Calcula o lucro
      double lucro = faturamento - (comissao + despesas);

      // Atualiza o maior lucro se o lucro calculado for maior
      if (lucro > maiorLucro) {
        setState(() {
          maiorLucro = lucro;
          okForLoad = true;
        });
        print("Atualizando maiorLucro para: $maiorLucro");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    mesSet();

    calcPercentage();
  }

  GlobalKey lastItemKey = GlobalKey();
  bool _hasScrolled = false;
  @override
  Widget build(BuildContext context) {
    final mesesOrdenados = ordenarMeses();
    void _scrollToLastItem() {
      final index = mesesOrdenados.length - 1;
      if (index >= 0) {
        final position =
            index * (MediaQuery.of(context).size.width * 0.07 + 16);
        print('Scrolling to position: $position'); // Debug statement
        _scrollController.animateTo(
          position,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (okForExibir) {
        Future.delayed(Duration(milliseconds: 500), () {
          _scrollToLastItem();
        });
      }
    });

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 5, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Lucro por mês ',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '(Últimos 12 meses)',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                CustomPaint(
                  painter: DottedLinePainter(
                    dashWidth: 10.0,
                    dashSpace: 5.0,
                    strokeWidth: 1.0,
                  ),
                  child: Container(),
                ),
                okForLoad != false && okForExibir != false
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: mesesOrdenados.map((mes) {
                              final isLastItem = mesesOrdenados.last == mes;
                              return GraficoBarras(
                                pronto: getBoolFilho,
                                okForLoad: okForLoad,
                                maiorLucroWidget: maiorLucro,
                                mes: mes,
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: Dadosgeralapp().primaryColor,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
