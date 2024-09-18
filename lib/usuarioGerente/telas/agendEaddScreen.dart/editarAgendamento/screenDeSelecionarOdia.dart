import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/funcoes/agendarHorario.dart';
import 'package:jimy/rotas/verificadorDeLogin.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/classes/horarios.dart';
import 'package:provider/provider.dart';

class EditarODiaDoAgendamento extends StatefulWidget {
  final Corteclass corte;
  const EditarODiaDoAgendamento({
    super.key,
    required this.corte,
  });

  @override
  State<EditarODiaDoAgendamento> createState() =>
      _EditarODiaDoAgendamentoState();
}

class _EditarODiaDoAgendamentoState extends State<EditarODiaDoAgendamento> {
  DateTime? dataSelectedInModal;
  List<Horarios> horarioFinal = [];
  List<Horarios> Horariopreenchidos = [];
  List<Horarios> _horariosPreenchidosParaEvitarDupNoCreate = [];
  List<String> selectedHorarios = [];
  bool prontoparaexibir = false;
  Future<void> loadListCortes() async {
    // Limpa as listas
    horarioFinal.clear();
    Horariopreenchidos.clear();
    _horariosPreenchidosParaEvitarDupNoCreate.clear();

    // Cria uma lista temporária com os horários fixos
    List<Horarios> listaTemporaria = List.from(listaHorariosFixos);
    DateTime? mesSelecionado = dataSelectedInModal;

    if (mesSelecionado != null) {
      try {
        // Carrega os cortes para profissionais
        await Provider.of<Agendarhorario>(context, listen: false)
            .loadCortesParaProfissionais(
          BarbeariaId: widget.corte.barbeariaId,
          mesSelecionado: mesSelecionado,
          DiaSelecionado: mesSelecionado.day,
          Barbeiroselecionado: widget.corte.ProfissionalSelecionado,
        );

        // Obtém a lista de horários preenchidos
        List<Horarios> listaCort =
            await Provider.of<Agendarhorario>(context, listen: false)
                .horariosListLoad;

        // Adiciona os horários preenchidos à lista de preenchidos
        for (var horario in listaCort) {
          Horariopreenchidos.add(
            Horarios(
              isActive: true,
              quantidadeHorarios: 1,
              horario: horario.horario,
              id: horario.id,
            ),
          );
          _horariosPreenchidosParaEvitarDupNoCreate.add(Horarios(
            isActive: true,
              horario: horario.horario, id: horario.id, quantidadeHorarios: 1));
        }

        // Remove os horários preenchidos da lista temporária
        listaTemporaria.removeWhere(
            (item) => listaCort.any((cort) => cort.horario == item.horario));

        // Atualiza a lista final com os horários disponíveis
        setState(() {
          horarioFinal = List.from(listaTemporaria);
          prontoparaexibir = true;
        });

        print(
            "o tamanho da lista de preenchidos é ${Horariopreenchidos.length}");
        print("este e o tamanho da lista final: ${horarioFinal.length}");
      } catch (e) {
        print("nao consegui realizar, erro: ${e}");
      }
    } else {
      print("problemas na hora ou dia");
    }
  }

  Future<void> ShowModalData() async {
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 14),
      ),
    ).then((selectUserDate) {
      try {
        if (selectUserDate != null) {
          setState(() {
            dataSelectedInModal = selectUserDate;
            loadListCortes();
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

  void showNotifyPreSave() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Alterar Agendamento?",
            style: GoogleFonts.openSans(
                textStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
            )),
          ),
          content: const Text(
              "Você realmente Deseja alterar as informações deste agendamento?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await removeAtualAndSetNew();
              },
              child: Text(
                "Confirmar Alteração",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool isloading = false;
  Future<void> removeAtualAndSetNew() async {
    // Adicione a lógica de verificação de horários aqui
    bool ocupar2EspacosAgenda = widget.corte.preencher2horarios;
    List<String> selectedHorarios = [];
    if (ocupar2EspacosAgenda == true) {
      // Encontrar o índice do horário selecionado na lista _horariosSemana
      int selectedIndex = listaHorariosFixos
          .indexWhere((horario) => horario.horario == hourSetForUser);

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

    // Continuar com o processo de remoção e agendamento
    Navigator.of(context).pop();
    setState(() {
      isloading = true;
    });
    try {
      String monthName =
          await DateFormat('MMMM', 'pt_BR').format(dataSelectedInModal!);
      Corteclass corte2 = Corteclass(
        valorQueOProfissionalGanhaPorCortes:
            widget.corte.valorQueOProfissionalGanhaPorCortes,
        valorQueOProfissionalGanhaPorProdutos:
            widget.corte.valorQueOProfissionalGanhaPorProdutos,
        porcentagemDoProfissional: widget.corte.porcentagemDoProfissional,
        horariosExtras: selectedHorarios,
        idDoServicoSelecionado: widget.corte.idDoServicoSelecionado,
        nomeServicoSelecionado: widget.corte.nomeServicoSelecionado,
        JaCortou: widget.corte.JaCortou,
        MesSelecionado: monthName,
        ProfissionalSelecionado: widget.corte.ProfissionalSelecionado,
        anoSelecionado: dataSelectedInModal!.year.toString(),
        barbeariaId: widget.corte.barbeariaId,
        clienteNome: widget.corte.clienteNome,
        dataSelecionadaDateTime: dataSelectedInModal!,
        diaSelecionado: dataSelectedInModal!.day.toString(),
        horarioSelecionado: hourSetForUser,
        id: widget.corte.id,
        momentoDoAgendamento: DateTime.now(),
        pagouPeloApp: widget.corte.pagouPeloApp,
        pagoucomcupom: widget.corte.pagoucomcupom,
        pontosGanhos: widget.corte.pontosGanhos,
        preencher2horarios: widget.corte.preencher2horarios,
        profissionalId: widget.corte.profissionalId,
        urlImagePerfilfoto: widget.corte.urlImagePerfilfoto,
        urlImageProfissionalFoto: widget.corte.urlImageProfissionalFoto,
        valorCorte: widget.corte.valorCorte,
      );
      Provider.of<Agendarhorario>(context, listen: false).DesmarcareReagendar(
        corte2: corte2,
        corte: widget.corte,
        idBarbearia: widget.corte.barbeariaId,
      );
      setState(() {
        isloading = false;
      });
      showDialog(
        context: context,
        barrierDismissible:
            false, // Evita que o diálogo seja fechado ao tocar fora dele
        builder: (ctx) {
          // Inicia um Timer para fechar o diálogo e redirecionar após 3 segundos
          Timer(Duration(seconds: 3), () {
            Navigator.of(ctx).pop(); // Fecha o diálogo
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VerificacaoDeLogado()),
            );
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Troca realizada!",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ),
            content: Text(
              "Aguarde um instante...",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black45),
              ),
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("erro ao alterar o agendamento:$e");
    }
  }

  int selectedIndex = -1;
  Map<int, Color> itemColors = {};
  Map<int, Color> _textColor = {};
  String hourSetForUser = "";

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                          color: Dadosgeralapp().primaryColor,
                        ),
                        Text(
                          "Atualizar data do agendamento",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dia selecionado:",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    dataSelectedInModal != null
                                        ? "${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)}"
                                        : "",
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        ShowModalData();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Dadosgeralapp().primaryColor,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        child: Text(
                                          dataSelectedInModal != null
                                              ? "Alterar"
                                              : "Selecionar Data",
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: dataSelectedInModal != null
                                ? Container(
                                    width: double.infinity,
                                    child: loading == false
                                        ? GridView.builder(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: horarioFinal.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 2.3,
                                              childAspectRatio: 2.3,
                                            ),
                                            itemBuilder:
                                                (BuildContext ctx, int index) {
                                              Color color = selectedIndex ==
                                                      index
                                                  ? Dadosgeralapp().primaryColor
                                                  : Dadosgeralapp()
                                                      .tertiaryColor;
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex =
                                                        selectedIndex == index
                                                            ? -1
                                                            : index;

                                                    hourSetForUser =
                                                        horarioFinal[index]
                                                            .horario;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 3,
                                                      horizontal: 3),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.elliptical(
                                                                20, 20),
                                                        bottomRight:
                                                            Radius.elliptical(
                                                                20, 20),
                                                        topLeft:
                                                            Radius.elliptical(
                                                                20, 20),
                                                        topRight:
                                                            Radius.elliptical(
                                                                20, 20),
                                                      ),
                                                      color: color,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      "${horarioFinal[index].horario}",
                                                      style:
                                                          GoogleFonts.openSans(
                                                              textStyle:
                                                                  const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Image.asset(
                                            "imagesapp/selecionedata.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Selecione um Dia",
                                          style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (dataSelectedInModal != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: showNotifyPreSave,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      "Salvar Alteração",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
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
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
