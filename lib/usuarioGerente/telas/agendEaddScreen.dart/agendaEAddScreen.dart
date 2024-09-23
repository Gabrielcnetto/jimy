import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/CorteClass.dart';
import 'package:Dimy/usuarioGerente/classes/barbeiros.dart';
import 'package:Dimy/usuarioGerente/classes/horarios.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/telas/abrirApenasComanda/abrirApenasComanda.dart';
import 'package:Dimy/usuarioGerente/telas/agendEaddScreen.dart/components/AgendarHorariosScreen.dart';
import 'package:Dimy/usuarioGerente/telas/agendEaddScreen.dart/components/agendaCarregadaHorarios.dart';
import 'package:Dimy/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/botaoDeConfiguracaoAgenda.dart';
import 'package:Dimy/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/editarAgendamento.dart';
import 'package:Dimy/usuarioGerente/telas/cadastrarDespesa/CadastrarDespesa.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AgendaEAddScreen extends StatefulWidget {
  const AgendaEAddScreen({super.key});

  @override
  State<AgendaEAddScreen> createState() => _AgendaEAddScreenState();
}

class _AgendaEAddScreenState extends State<AgendaEAddScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _animation;
  bool exibindoItens = false;
  @override
  void initState() {
    super.initState();

    loadingTotal();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose(); // Libera os recursos do controlador
    super.dispose();
  }

  bool isloading = false;
  int? diaSelecionadoSegundo;
  String? mesSelecionadoSegundo;
  int? anoAtual;
  List<Barbeiros> _barbeiro = [];
  void loadingTotal() async {
    try {
      setState(() {
        isloading = true;
      });
      setDaysAndMonths();
      await Provider.of<Getsdeinformacoes>(context, listen: false)
          .getListaProfissionais();

      ajusteIndexDoProfissionalPrimeiroLoad();
      await primeiroGetNomeProfissionalDefault();
      await attViewSchedule(
        year: lastSevenYears[0],
        dia: lastSevenDays[0],
        mes: lastSevenMonths[0],
        proffName: profSelecionado,
      );
      setState(() {
        isloading = false;
      });
    } catch (e) {
      setState(() {
        isloading = false;
      });
    }
  }

  String profSelecionado = "";
  Future<void> attViewSchedule({
    required int year,
    required int dia,
    required String mes,
    required String proffName,
  }) async {
    print("dia selecionado: $dia e o mês é: $mes");
    print("cliquei aqui");
    try {
      setState(() {
        diaSelecionadoSegundo = dia;
        mesSelecionadoSegundo = mes;
        anoAtual = year;
      });
      Provider.of<Getsdeinformacoes>(context, listen: false)
          .carregarAgendaAposSelecionarDiaEprofissional(
        year: year,
        selectDay: dia,
        selectMonth: mes,
        proffName: profSelecionado,
      );
    } catch (e) {
      print("erro: $e");
      throw e;
    }
  }

  void ajusteIndexDoProfissionalPrimeiroLoad() {
    setState(() {
      selectedIndexBarbeiros = 0;
    });
  }

  primeiroGetNomeProfissionalDefault() async {
    setState(
      () {
        profSelecionado = Provider.of<Getsdeinformacoes>(context, listen: false)
            .profList[0]
            .name;
      },
    );
  }

  //
  List<int> lastSevenDays = [];
  List<String> lastSevenMonths = [];
  List<String> lastSevenWeekdays = [];
  List<int> lastSevenYears = [];
  void setDaysAndMonths() {
    initializeDateFormatting('pt_BR');
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      int dayOfMonth = int.parse(DateFormat('d').format(date));
      String monthName = DateFormat('MMMM', 'pt_BR').format(date);
      String weekdayName = DateFormat('EEEE', 'pt_BR').format(date);
      int year = date.year;
      lastSevenDays.add(dayOfMonth);
      lastSevenMonths.add(monthName);
      lastSevenWeekdays.add(weekdayName);
      lastSevenYears.add(year);
    }
  }

  int selectedIndex = 0;
  int selectedIndexBarbeiros = -1;
  List<Horarios> _horariosListFixa = listaHorariosFixos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Agenda completa",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => BotaoDeConfiguracap()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.settings,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            lastSevenDays.length,
                            (index) {
                              int day = lastSevenDays[index];
                              String month = lastSevenMonths[index];
                              String weekday = lastSevenWeekdays[index];
                              int anoAtualGet = lastSevenYears[index];
                              String firstLetterOfMonth = month.substring(0, 1);
                              String tresPrimeirasLetras =
                                  weekday.substring(0, 3);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    tresPrimeirasLetras,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        diaSelecionadoSegundo = day;
                                        mesSelecionadoSegundo = month;
                                        anoAtual = anoAtualGet;
                                      });
                                      attViewSchedule(
                                        year: anoAtualGet,
                                        dia: day,
                                        mes: month,
                                        proffName: profSelecionado,
                                      );
                                      print("ano:${anoAtual}");
                                      print("mes:${month}");
                                      print("dia:${day}");
                                      print(index);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.115,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.elliptical(90, 90),
                                          bottomRight:
                                              Radius.elliptical(90, 90),
                                          topLeft: Radius.elliptical(90, 90),
                                          topRight: Radius.elliptical(90, 90),
                                        ),
                                        color: selectedIndex == index
                                            ? Dadosgeralapp().primaryColor// Cor do item selecionado
                                            : Colors.grey.shade200, // Cor padrão dos outros itens
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$day",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: selectedIndex == index ? Colors.white :Color.fromRGBO(54, 54, 54, 1),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: StreamBuilder(
                          stream: Provider.of<Getsdeinformacoes>(context,
                                  listen: false)
                              .getProfissionais,
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState == ConnectionState) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Dadosgeralapp().primaryColor,
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  "Nenhum profissional encontrado",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<Barbeiros> listaBarbeiros =
                                snapshot.data as List<Barbeiros>;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    listaBarbeiros.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Barbeiros item = entry.value;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          profSelecionado = item.name;
                                          selectedIndexBarbeiros =
                                              index; // Atualiza o índice selecionado
                                        });
                                        attViewSchedule(
                                          year: anoAtual!,
                                          dia: diaSelecionadoSegundo!,
                                          mes: mesSelecionadoSegundo!,
                                          proffName: profSelecionado,
                                        );
                                        print("anoAtual:${anoAtual}");
                                        print(
                                            "mes Atual:${mesSelecionadoSegundo}");
                                        print(
                                            "dia Atual:${diaSelecionadoSegundo}");
                                        print("#2:${item.name}");
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.14,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.08,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Image.network(
                                                  item.urlImageFoto ??
                                                      'https://example.com/default_avatar.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical:
                                                      5), // Espaço interno
                                              decoration: BoxDecoration(
                                                color: selectedIndexBarbeiros ==
                                                        index
                                                    ? Dadosgeralapp()
                                                        .tertiaryColor
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item.name,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.clip,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        selectedIndexBarbeiros ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        child: StreamBuilder(
                          stream: Provider.of<Getsdeinformacoes>(
                            context,
                            listen: true,
                          ).CorteslistaManager,
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
                              print("estamos sem horarios agendados");
                              return LinhaTempoProfissionalSelecionado();
                            }
                            final List<Corteclass>? cortes = snapshot.data;
                            final List<Corteclass> cortesFiltrados = cortes!
                                .where((corte) => corte.clienteNome != "extra")
                                .toList();
                            final List<Corteclass> corteFiltradoFinal =
                                cortesFiltrados
                                    .where((corte) => corte.JaCortou != true)
                                    .toList();
                            return Column(
                              children: _horariosListFixa.map((horario) {
                                List<Corteclass> cortesParaHorario =
                                    corteFiltradoFinal
                                        .where((corte) =>
                                            corte.horarioSelecionado ==
                                            horario.horario)
                                        .toList();
                                return Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: TimelineTile(
                                        alignment: TimelineAlign.manual,
                                        lineXY: 0,
                                        axis: TimelineAxis.vertical,
                                        indicatorStyle: IndicatorStyle(
                                          color: Colors.grey.shade300,
                                          height: 5,
                                        ),
                                        beforeLineStyle: LineStyle(
                                          color: Colors.grey.shade300,
                                          thickness: 2,
                                        ),
                                        endChild: Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 100,
                                                    child: Text(
                                                      horario.horario,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Dadosgeralapp()
                                                            .tertiaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              cortesParaHorario.isNotEmpty
                                                  ? Expanded(
                                                      child: Column(
                                                      children:
                                                          cortesParaHorario
                                                              .map((corte) {
                                                        return corte.clienteNome !=
                                                                "BARBANULO"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (ctx) => EditarAgendamento(
                                                                                  corte: corte,
                                                                                )));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.18,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Dadosgeralapp()
                                                                          .tertiaryColor,
                                                                      borderRadius: corte.preencher2horarios ==
                                                                              false
                                                                          ? BorderRadius.circular(
                                                                              10)
                                                                          : BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              topRight: Radius.circular(10)),
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Ínicio:",
                                                                              style: GoogleFonts.poppins(
                                                                                textStyle: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.white24,
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              corte.horarioSelecionado,
                                                                              style: GoogleFonts.poppins(
                                                                                textStyle: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.white,
                                                                                  fontSize: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.65,
                                                                              child: Text(
                                                                                corte.nomeServicoSelecionado,
                                                                                style: GoogleFonts.poppins(
                                                                                  textStyle: TextStyle(
                                                                                    fontSize: 16,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.65,
                                                                              child: Text(
                                                                                corte.clienteNome,
                                                                                style: GoogleFonts.poppins(
                                                                                  textStyle: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              2,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                                                              padding: EdgeInsets.all(5),
                                                                              child: Icon(
                                                                                Icons.open_in_new,
                                                                                size: 15,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.18,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Dadosgeralapp()
                                                                      .tertiaryColor,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            10),
                                                              );
                                                      }).toList(),
                                                    ))
                                                  : Expanded(
                                                      child: Container(
                                                        height: 80,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            "Horário disponível",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (isloading == true) ...[
                Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Dadosgeralapp().primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              icon: Icons.receipt_long,
              iconColor: Colors.black,
              title: "Abrir comanda",
              titleStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              bubbleColor: Colors.white,
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AbrirApenasComanda(),
                ));
              },
            ),
            Bubble(
              icon: Icons.add_box,
            iconColor: Colors.black,
              title: "Agendar horário",
              titleStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              bubbleColor: Colors.white,
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AgendarHorarioScreen(),
                ));
              },
            ),
            Bubble(
              icon: Icons.shopping_cart_checkout,
            iconColor: Colors.black,
              title: "Cadastrar despesa",
              titleStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              bubbleColor: Colors.white,
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => cadastrarNovaDespesa(),
                ));
              },
            ),
          ],
          iconColor: Colors.white,
          backGroundColor: Dadosgeralapp().primaryColor,
          onPress: () {
            setState(() {
              exibindoItens = !exibindoItens;
            });
            _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward();
          },
          iconData: exibindoItens ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          animation: _animation!,
        ));
  }
}
