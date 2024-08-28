import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/components/AgendarHorariosScreen.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/components/agendaCarregadaHorarios.dart';
import 'package:provider/provider.dart';

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

    // Chama o initState da classe pai
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
  void loadingTotal() async {
    try {
      setState(() {
        isloading = true;
      });
      setDaysAndMonths();
      await Provider.of<Getsdeinformacoes>(context, listen: false)
          .getListaProfissionais();
      setState(() {
        isloading = false;
      });
    } catch (e) {}
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

  int selectedIndex = 0;
  int selectedIndexBarbeiros = -1;
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
                                        selectedIndex =
                                            index; // Marca o índice como selecionado
                                      });
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
                                            ? Dadosgeralapp()
                                                .tertiaryColor // Cor do item selecionado
                                            : Dadosgeralapp()
                                                .primaryColor, // Cor padrão dos outros itens
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  children: listaBarbeiros
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    Barbeiros item = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndexBarbeiros =
                                                index; // Atualiza o índice selecionado
                                          });
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
                                                  color:
                                                      selectedIndexBarbeiros ==
                                                              index
                                                          ? Dadosgeralapp()
                                                              .tertiaryColor
                                                          : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  item.name,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                ));
                          },
                        ),
                      ),
                      LinhaTempoProfissionalSelecionado(),
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
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AgendarHorarioScreen(),
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
