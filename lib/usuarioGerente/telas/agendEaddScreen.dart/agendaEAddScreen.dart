import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/components/agendaCarregadaHorarios.dart';

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
    super.initState(); // Chama o initState da classe pai
    setDaysAndMonths();
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

  //
  List<int> lastSevenDays = [];
  List<String> lastSevenMonths = [];
  List<String> lastSevenWeekdays = [];

  void setDaysAndMonths() {
    initializeDateFormatting('pt_BR');
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      int dayOfMonth = int.parse(DateFormat('d').format(date));
      String monthName = DateFormat('MMMM', 'pt_BR').format(date);
      String weekdayName = DateFormat('EEEE', 'pt_BR').format(date);
      lastSevenDays.add(dayOfMonth);
      lastSevenMonths.add(monthName);
      lastSevenWeekdays.add(weekdayName);
    }
  }

  void showVerificationModalManager() {
    print("teste");
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.settings,
                          size: 20,
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
                          String firstLetterOfMonth = month.substring(0, 1);
                          String tresPrimeirasLetras = weekday.substring(0, 3);

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
                                    selectedIndex =
                                        index; // Marca o índice como selecionado
                                  });
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.115,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.elliptical(90, 90),
                                      bottomRight: Radius.elliptical(90, 90),
                                      topLeft: Radius.elliptical(90, 90),
                                      topRight: Radius.elliptical(90, 90),
                                    ),
                                    color: selectedIndex == index
                                        ? Dadosgeralapp()
                                            .tertiaryColor // Cor do item selecionado
                                        : Dadosgeralapp()
                                            .primaryColor, // Cor padrão dos outros itens
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$day",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
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
                  SizedBox(
                    height: 10,
                  ),
                  Text("profissionais"),
                  SizedBox(
                    height: 10,
                  ),
                  LinhaTempoProfissionalSelecionado(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              icon: Icons.add_box,
              iconColor: Dadosgeralapp().primaryColor,
              title: "Agendar horário",
              titleStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              bubbleColor: Colors.white,
              onPress: showVerificationModalManager,
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
