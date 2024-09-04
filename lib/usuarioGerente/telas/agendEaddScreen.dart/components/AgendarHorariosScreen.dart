import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/funcoes/agendarHorario.dart';
import 'package:jimy/rotas/confirmacaoAgendamento.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class AgendarHorarioScreen extends StatefulWidget {
  const AgendarHorarioScreen({super.key});

  @override
  State<AgendarHorarioScreen> createState() => _AgendarHorarioScreenState();
}

class _AgendarHorarioScreenState extends State<AgendarHorarioScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).getListaServicos();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
    loadloadIdBarbearia();
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  //funcoes do load e puxar quais tem preenchidos e também enviar um novo - inicio
  bool isloading = false;
  final numberControler = TextEditingController();
  final nomeClienteControler = TextEditingController();
  List<Horarios> horarioFinal = [];
  List<Horarios> Horariopreenchidos = [];
  DateTime? dataSelectedInModal;
  String profissionalSelecionado = "";
  String idDoProfissionalSelecionado = "";
  String horarioClicadoeSelecionado = "";
  String nomeServicoSelecionado = "";
  String urlImagemPerfilProfissional = "";
  String idServicoSelecionado = "";
  double valorServicoSelecionado = 0.0;
  bool ocupar2EspacosAgenda = false;
  double porcentagemDoProfissional = 100;
  //load dos horários - inicio
  Future<void> loadListCortes() async {
    
    horarioFinal.clear();
    Horariopreenchidos.clear();
    List<Horarios> listaTemporaria = [];
    List<Horarios> _horariosLivres = listaHorariosFixos;
    DateTime? mesSelecionado = dataSelectedInModal;
    listaTemporaria.addAll(_horariosLivres);
    if (mesSelecionado != null) {
      try {
        await Provider.of<Agendarhorario>(context, listen: false)
            .loadCortesParaProfissionais(
          BarbeariaId: loadIdBarbearia!,
          mesSelecionado: mesSelecionado,
          DiaSelecionado: mesSelecionado.day,
          Barbeiroselecionado: profissionalSelecionado,
        );
        List<Horarios> listaCort =
            await Provider.of<Agendarhorario>(context, listen: false)
                .horariosListLoad;

        for (var horario in listaCort) {
          Horariopreenchidos.add(
            Horarios(
              quantidadeHorarios: 1,
              horario: horario.horario,
              id: horario.id,
            ),
          );
          _horariosPreenchidosParaEvitarDupNoCreate.add(Horarios(
              horario: horario.horario, id: horario.id, quantidadeHorarios: 1));
        }
        print(
            "o tamanho da lista de preenchidos é ${Horariopreenchidos.length}");
        setState(() {
          horarioFinal = List.from(listaTemporaria);
        });
        setState(() {
          prontoparaexibir = true;
        });

        print("este e o tamanho da lista final: ${horarioFinal.length}");
      } catch (e) {
        print("nao consegu realizar, erro: ${e}");
      }
    } else {
      print("problemas na hora ou dia");
    }
  }

  //load dos horários - fim
  //funcao de agendar:

  List<Horarios> _horariosPreenchidosParaEvitarDupNoCreate = [];
  Future<void> FuncaodeAgendar() async {
    Navigator.of(context).pop();
    setState(() {
      isloading = true;
    });

    //verificacao caso seja um procedimento mais demorado para adicionar as listas de horarios
    List<String> selectedHorarios = [];
    if (ocupar2EspacosAgenda == true) {
      // Encontrar o índice do horário selecionado na lista _horariosSemana
      int selectedIndex = listaHorariosFixos.indexWhere(
          (horario) => horario.horario == horarioClicadoeSelecionado);

      if (selectedIndex != -1 &&
          selectedIndex + 3 < listaHorariosFixos.length) {
        for (int i = 1; i <= 3; i++) {
          String horarioExtra = listaHorariosFixos[selectedIndex + i].horario;
          // Verificar se o horário extra está presente na lista de horários preenchidos
          bool horarioJaPreenchido = _horariosPreenchidosParaEvitarDupNoCreate
              .any((horario) => horario.horario == horarioExtra);
          print(
              "o tamanho da lista é # ${_horariosPreenchidosParaEvitarDupNoCreate.length}");
          if (horarioJaPreenchido == true) {
            // Mostrar um dialog para o usuário selecionar outro horário
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Horário Indisponível',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                  ),
                  content: Text(
                    'O Serviço selecionado leva mais tempo, ao selecionar este horário pode bagunçar sua rotina. Escolha outro por favor.',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Fechar o dialog
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Escolher outro',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            setState(() {
              isloading = false;
            });
            // Abortar a adição ao provider
            return;
          }

          selectedHorarios.add(horarioExtra);
        }
      }
    }

    try {
      String monthName =
          await DateFormat('MMMM', 'pt_BR').format(dataSelectedInModal!);
      final Corteclass _corteCriado = Corteclass(
        porcentagemDoProfissional: porcentagemDoProfissional,
        horariosExtras: selectedHorarios,
        idDoServicoSelecionado: idServicoSelecionado,
        nomeServicoSelecionado: nomeServicoSelecionado,
        JaCortou: false,
        MesSelecionado: monthName,
        ProfissionalSelecionado: profissionalSelecionado,
        anoSelecionado: dataSelectedInModal!.year.toString(),
        barbeariaId: loadIdBarbearia!,
        clienteNome: nomeClienteControler.text,
        dataSelecionadaDateTime: dataSelectedInModal!,
        diaSelecionado: dataSelectedInModal!.day.toString(),
        horarioSelecionado: horarioClicadoeSelecionado,
        id: Random().nextDouble().toString(),
        momentoDoAgendamento: DateTime.now(),
        pagouPeloApp: false,
        pagoucomcupom: false,
        pontosGanhos: 0,
        preencher2horarios: ocupar2EspacosAgenda,
        profissionalId: idDoProfissionalSelecionado,
        urlImagePerfilfoto: Dadosgeralapp().defaultAvatarImage,
        urlImageProfissionalFoto: urlImagemPerfilProfissional,
        valorCorte: valorServicoSelecionado,
      );
      await Provider.of<Agendarhorario>(context, listen: false)
          .agendarHorararioParaProfissionais(
            porcentagemProfissional: porcentagemDoProfissional,
        idDaBarbearia: loadIdBarbearia!,
        corte: _corteCriado,
      );

      setState(() {
        isloading = false;
      });
      Navigator.of(context).push(
        DialogRoute(
          context: context,
          builder: (ctx) => ConfirmacaoAgendamento(),
        ),
      );
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("ocorreu um erro");
      throw e;
    }
  }
  //funcoes do load e puxar quais tem preenchidos e também enviar um novo - FIM

  bool verServicos = true;

  int selectedIndexHorario = -1;

  void loadListAndView() async {
    await Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaServicos();
    await Provider.of<Getsdeinformacoes>(context, listen: false)
        .serviceListStream;
    setState(() {
      verServicos = !verServicos;
    });
  }

  int _selectedIndex = -1;
  int _selectedIndexService = -1;

  //data
  bool prontoparaexibir = true;

  DateTime? DataFolgaDatabase;
  Future<void> ShowModalData() async {
    setState(() {
      dataSelectedInModal = null;
    });
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      selectableDayPredicate: (DateTime day) {
        // Desativa domingos
        if (day.weekday == DateTime.sunday) {
          return false;
        }
        // Bloqueia a data contida em dataOffselectOfManger
        if (DataFolgaDatabase != null &&
            day.year == DataFolgaDatabase!.year &&
            day.month == DataFolgaDatabase!.month &&
            day.day == DataFolgaDatabase!.day) {
          return false;
        }
        return true;
      },
    ).then((selectUserDate) {
      try {
        if (selectUserDate != null) {
          setState(() {
            dataSelectedInModal = selectUserDate;
            loadListCortes();
            FocusScope.of(context).requestFocus(FocusNode()); 
          });
        }
      } catch (e) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text("${e}"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o modal
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
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
                              size: 20,
                              color: Dadosgeralapp().primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Agende um horário",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Aqui você pode agendar horários para os seus clientes. Recomende o App do ${Dadosgeralapp().nomeSistema} para o próprio cliente agendar!",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //container do nome do cliente
                      Form(
                        key: _keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Dadosgeralapp().primaryColor),
                                  child: const Text(
                                    "1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Nome do cliente",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              child: TextFormField(
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite o nome do cliente';
                                  }
                                  return null;
                                },
                                controller: nomeClienteControler,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Container do contato
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Dadosgeralapp().primaryColor),
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Telefone de contato",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(Não obrigatório)",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black38,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              controller: numberControler,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //fim container contato
                      //Container serviços
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Dadosgeralapp().primaryColor),
                              child: const Text(
                                "3",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(54, 54, 54, 1),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Seus serviços",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<Getsdeinformacoes>(
                                                    context,
                                                    listen: false)
                                                .getListaServicos();
                                            Provider.of<Getsdeinformacoes>(
                                                    context,
                                                    listen: false)
                                                .serviceListStream;
                                            setState(() {
                                              verServicos = !verServicos;
                                            });
                                          },
                                          child: Icon(
                                            verServicos == false
                                                ? Icons.arrow_drop_down
                                                : Icons.arrow_drop_up,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (verServicos == true)
                                    StreamBuilder(
                                      stream: Provider.of<Getsdeinformacoes>(
                                              context,
                                              listen: false)
                                          .getServiceList,
                                      builder: (ctx, snaphost) {
                                        if (snaphost.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  Dadosgeralapp().primaryColor,
                                            ),
                                          );
                                        }
                                        if (!snaphost.hasData ||
                                            snaphost.data!.isEmpty ||
                                            snaphost.data == null) {
                                          return Center(
                                            child: Text(
                                              "Sem serviços Cadastrados",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<Servico> listaServico =
                                            snaphost.data as List<Servico>;
                                        return Column(
                                          children: listaServico
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            Servico servicoItem = entry.value;

                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedIndexService = index;
                                                  valorServicoSelecionado =
                                                      listaServico[index].price;
                                                  nomeServicoSelecionado =
                                                      listaServico[index].name;
                                                  idServicoSelecionado =
                                                      listaServico[index].id;
                                                  ocupar2EspacosAgenda =
                                                      listaServico[index]
                                                          .ocupar2vagas;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${servicoItem.name} - ",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .green
                                                                  .shade600,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Icon(
                                                              Icons.paid,
                                                              size: 12,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      54,
                                                                      54,
                                                                      54,
                                                                      1),
                                                            ),
                                                          ),
                                                          SizedBox(width: 2),
                                                          Text(
                                                            "R\$${servicoItem.price.toStringAsFixed(2).replaceAll('.', ',')}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white38,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    _selectedIndexService ==
                                                            index
                                                        ? Icons.toggle_on
                                                        : Icons.toggle_off,
                                                    size: 40,
                                                    color:
                                                        _selectedIndexService ==
                                                                index
                                                            ? Colors.white
                                                            : Colors
                                                                .grey.shade600,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Dadosgeralapp().primaryColor),
                            child: const Text(
                              "4",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Selecione o profissional",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamBuilder(
                        stream: Provider.of<Getsdeinformacoes>(context,
                                listen: false)
                            .getProfissionais,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: Dadosgeralapp().primaryColor,
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.isEmpty ||
                              snapshot.data == null) {
                            return Center(
                              child: Text(
                                "Sem profissionais Cadastrados",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<Barbeiros> listaBarbeiros =
                              snapshot.data as List<Barbeiros>;
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              const crossAxisCount = 2;
                              const crossAxisSpacing = 10.0;
                              const mainAxisSpacing = 10.0;
                              const childAspectRatio =
                                  1.0; // Ajuste conforme necessário

                              // Calcule a largura disponível para cada item
                              final itemWidth = (constraints.maxWidth -
                                      (crossAxisCount - 1) * crossAxisSpacing) /
                                  crossAxisCount;
                              final itemHeight = itemWidth * childAspectRatio;

                              // Calcule o número total de linhas necessárias
                              final totalItems = listaBarbeiros.length;
                              final totalLines =
                                  (totalItems / crossAxisCount).ceil();

                              // Calcule a altura total do GridView
                              final totalHeight = totalLines * itemHeight +
                                  (totalLines - 1) * mainAxisSpacing;

                              return Container(
                                height: totalHeight,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: crossAxisSpacing,
                                    mainAxisSpacing: mainAxisSpacing,
                                    childAspectRatio: childAspectRatio,
                                  ),
                                  itemCount: listaBarbeiros.length,
                                  itemBuilder: (ctx, index) {
                                    final isSelected = _selectedIndex == index;
                                    return GestureDetector(
                                      onTap: () {
                                        if (_keyForm.currentState!.validate()) {
                                          setState(() {
                                            _selectedIndex =
                                                isSelected ? -1 : index;
                                            dataSelectedInModal = null;
                                            horarioClicadoeSelecionado = "";
                                            selectedIndexHorario =
                                                -1; // Atualiza para -1 se já estiver selecionado
                                            profissionalSelecionado =
                                                listaBarbeiros[index].name;
                                            idDoProfissionalSelecionado =
                                                listaBarbeiros[index].id;
                                            urlImagemPerfilProfissional =
                                                listaBarbeiros[index]
                                                    .urlImageFoto;
                                                    porcentagemDoProfissional = listaBarbeiros[index].porcentagemCortes;
                                           
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Digite o nome do cliente",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                content: Text(
                                                  "Antes de selecionar o profissional, digite o nome do cliente",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Voltar",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Dadosgeralapp()
                                                                .primaryColor,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            width: double
                                                .infinity, // Preenche a largura disponível
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                listaBarbeiros[index]
                                                    .urlImageFoto,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ), // Sobreposição preta
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (profissionalSelecionado.isNotEmpty && nomeServicoSelecionado != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Dadosgeralapp().primaryColor),
                              child: const Text(
                                "5",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Selecione uma data",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (profissionalSelecionado.isNotEmpty)
                        SizedBox(
                          height: 5,
                        ),
                      if (profissionalSelecionado.isNotEmpty)
                        InkWell(
                          onTap: ShowModalData,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dataSelectedInModal != null
                                      ? DateFormat("dd/MM/yyyy")
                                          .format(dataSelectedInModal!)
                                      : "Clique para escolher",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      if (dataSelectedInModal != null &&
                          profissionalSelecionado.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Dadosgeralapp().primaryColor),
                              child: const Text(
                                "6",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Selecione um horário",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (dataSelectedInModal != null &&
                          profissionalSelecionado.isNotEmpty)
                        SizedBox(
                          height: 15,
                        ),
                      if (dataSelectedInModal != null &&
                          profissionalSelecionado.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              color: Colors.green.shade600,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "- Já preenchido | ",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              color: Color.fromRGBO(54, 54, 54, 1),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "- Livre | ",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 15,
                              height: 15,
                              color: Dadosgeralapp().primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "- Selecionado",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (dataSelectedInModal != null &&
                          profissionalSelecionado.isNotEmpty)
                        SizedBox(
                          height: 5,
                        ),
                      if (dataSelectedInModal != null &&
                          profissionalSelecionado.isNotEmpty)
                        Container(
                          width: double.infinity,
                          //  height: heighScreen * 0.64,
                          child: prontoparaexibir == true
                              ? GridView.builder(
                                  padding: const EdgeInsets.only(top: 5),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: horarioFinal.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.3,
                                    childAspectRatio: 2.3,
                                  ),
                                  itemBuilder: (BuildContext ctx, int index) {
                                    bool presentInBothLists =
                                        Horariopreenchidos.any((horario) =>
                                            horarioFinal[index].horario ==
                                            horario
                                                .horario); // Verifica se o horário está presente nas duas listas
                                    Color color = selectedIndexHorario == index
                                        ? Dadosgeralapp()
                                            .primaryColor // Se o item estiver selecionado, a cor é verde
                                        : presentInBothLists
                                            ? Colors.green
                                                .shade600 // Se o horário estiver presente em ambas as listas, a cor é vermelha
                                            : Color.fromRGBO(54, 54, 54,
                                                1); // Caso contrário, use a cor primária do Estabelecimento
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndexHorario =
                                              selectedIndexHorario == index
                                                  ? -1
                                                  : index;

                                          horarioClicadoeSelecionado =
                                              horarioFinal[index].horario;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 3),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.elliptical(20, 20),
                                              bottomRight:
                                                  Radius.elliptical(20, 20),
                                              topLeft:
                                                  Radius.elliptical(20, 20),
                                              topRight:
                                                  Radius.elliptical(20, 20),
                                            ),
                                            color: color,
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "${horarioFinal[index].horario}",
                                            style: GoogleFonts.openSans(
                                                textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 15,
                                            )),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      if (dataSelectedInModal != null &&
                          profissionalSelecionado.isNotEmpty &&
                          horarioClicadoeSelecionado.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 25),
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(25, 25),
                                        topRight: Radius.elliptical(25, 25),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                color: Colors.black,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Resumo do agendamento",
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  "Revise os dados",
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black38,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 15,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //nome do cliente
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Nome do cliente",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${nomeClienteControler.text}",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              //contato
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Telefone de contato",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ),

                                                  Text(
                                                    "${numberControler.text}",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  //Contato
                                                ],
                                              ),
                                              //data
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Data",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ),

                                                  Text(
                                                    "${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)}",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  //Contato
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              //horário
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Horário",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ),

                                                  Text(
                                                    "${horarioClicadoeSelecionado}",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  //Contato
                                                ],
                                              ),
                                              //profissional
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Profissional selecionado",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ),

                                                  Text(
                                                    "${profissionalSelecionado}",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  //Contato
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: FuncaodeAgendar,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            decoration: BoxDecoration(
                                              color:
                                                  Dadosgeralapp().primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              "Agendar agora",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(54, 54, 54, 1),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Próximo",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
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
