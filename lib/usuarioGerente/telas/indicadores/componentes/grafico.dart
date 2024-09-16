import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class GraficoBarras extends StatefulWidget {
  final Function(bool) pronto;
  final bool okForLoad;
  final double maiorLucroWidget;
  final String mes;



  const GraficoBarras({
    super.key,
    required this.okForLoad,
    required this.pronto,
    required this.mes,
 
    required this.maiorLucroWidget,
  });

  @override
  State<GraficoBarras> createState() => _GraficoBarrasState();
}

class _GraficoBarrasState extends State<GraficoBarras> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDadosFaturamento();
    
    print("maiorLucroWidget:${widget.maiorLucroWidget}");
  }

  DateTime dateMomento = DateTime.now();
  double faturamentoMes = 0;
  double comissaoMes = 0;
  double valorRecorrente = 0;
  double valorDespesaEsteMes = 0;
  double ValorLucroFinal = 0;
  double custoTotal = 0;
  double porcentagemFinal = 0.0;
  bool okForExib = false;
  int ano = 0;
  void calcularPercentual(double valor, double total) {
    if (total == 0.0) {
      setState(() {
        porcentagemFinal = (0 / 0).clamp(0.0, 1.0);
        ; // Se o total é 0, a porcentagem é 0
        okForExib = true;
        widget.pronto(true);
      });
    } else {
      setState(() {
        // Calcula a porcentagem como uma fração entre 0 e 1
        porcentagemFinal = (valor / total).clamp(0.0, 1.0);
        // Verifica o valor calculado
        okForExib = true;
        widget.pronto(true);
      });
      print(
          "#calcFinalTotal:${widget.mes},lucro maior:${widget.maiorLucroWidget}, e a porcentagem final:${porcentagemFinal}");
    }
  }

  Future<void> getDadosFaturamento() async {
    try {
      String mesEstamos = DateFormat('MMMM', 'pt_BR').format(dateMomento);
      DateTime agora = DateTime.now();
      DateFormat formatter = DateFormat('MMMM', 'pt_BR');

      // Formata e analisa o mês selecionado
      DateTime mesSelecionadoDate = formatter.parse(widget.mes, true);
      int mesSelecionado = mesSelecionadoDate.month;
      int anoSelecionado = agora.year;

      // Ajusta o ano se o mês selecionado for maior que o mês atual
      if (mesSelecionado > agora.month) {
        anoSelecionado = agora.year - 1;
      } 
        setState(() {
          ano = anoSelecionado;
        });
      // Obtém os dados do banco de acordo com o ano e mês ajustados
      double dbDataMesSelecionado =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getFaturamentoMensalGerenteMesSelecionado(
                anoDeBusca: anoSelecionado,
                mesSelecionado: widget.mes,
              ) ??
              0.0;

      double? comissao =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getComissaoTotalMensalGerenteMes(
                ano: anoSelecionado,
                mes: widget.mes,
              ) ??
              0.0;
      double? recorrente =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getValorDeRecorrentesEsteMes() ??
              0.0;
      double? _valorDespesaEsteMes =
          await Provider.of<Getsdeinformacoes>(context, listen: false)
                  .getDespesaMesSelecionado(
                anoDeBusca: anoSelecionado,
                mesSelecionado: widget.mes,
              ) ??
              0.0;

      if (mesEstamos.toLowerCase() == widget.mes) {
        setState(() {
          faturamentoMes = dbDataMesSelecionado;
          comissaoMes = comissao!;
          valorDespesaEsteMes = _valorDespesaEsteMes;
          valorRecorrente = recorrente;
          calculoTotal();
        });
      }
      if (mesEstamos.toLowerCase() != widget.mes) {
        setState(() {
          valorDespesaEsteMes = _valorDespesaEsteMes;
          faturamentoMes = dbDataMesSelecionado;
          comissaoMes = comissao!;

          calculoTotal();
        });
      }
    } catch (e) {
      print("ao buscar os meses ocorreu isto:$e");
    }
  }

  void calculoTotal() {
    //primeiroSomaDeDespesas
    try {
      print("#tab comissaoMes: ${comissaoMes}");
      print("#tab comissaoMes: ${valorRecorrente}");
      print("#tab valorDespesaEsteMes :${valorDespesaEsteMes}");
      setState(() {
        custoTotal = (comissaoMes + valorRecorrente + valorDespesaEsteMes);
        ValorLucroFinal = (faturamentoMes) - (custoTotal);
      });
      calcularPercentual(ValorLucroFinal, widget.maiorLucroWidget);
    } catch (e) {
      print("erro no calculo final");
    }
  }

  void _showOverlay(BuildContext context, Offset clickPosition) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        // Definir o tamanho do overlay com base no conteúdo
        const double overlayWidth = 200; // Ajuste conforme o tamanho real
        const double overlayHeight = 100; // Ajuste conforme o tamanho real

        final mediaQuery = MediaQuery.of(context);
        final screenSize = mediaQuery.size;
        final overlayPadding =
            8.0; // Espaço adicional para garantir que o overlay não seja cortado

        double left = clickPosition.dx;
        double top = clickPosition.dy;

        // Ajustar a posição do overlay se necessário
        if (left + overlayWidth > screenSize.width) {
          left = screenSize.width - overlayWidth - overlayPadding;
        }
        if (top + overlayHeight > screenSize.height) {
          top = screenSize.height - overlayHeight - overlayPadding;
        }
        if (left < overlayPadding) {
          left = overlayPadding;
        }
        if (top < overlayPadding) {
          top = overlayPadding;
        }

        return Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: overlayWidth,
              height: overlayHeight,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Dadosgeralapp().infClick,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lucro de ${widget.mes} de ${ano}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'R\$${ValorLucroFinal.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Faturamento total: ",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        "R\$${faturamentoMes.toStringAsFixed(2).replaceAll('.', ',')}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Custo total: ",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        "R\$${custoTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    // Adiciona a entrada ao overlay
    overlay.insert(overlayEntry);

    // Remove a entrada do overlay após alguns segundos (opcional)
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      // Captura a posição do clique e mostra o overlay
                      _showOverlay(context, details.globalPosition);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (details) {
                      // Captura a posição do clique e mostra o overlay
                      _showOverlay(context, details.globalPosition);
                    },
                    child: FractionallySizedBox(
                      heightFactor: porcentagemFinal.clamp(0.0, 1.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().tertiaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.mes.substring(0, 3),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ));
  }
}
