import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class AgendarHorarioScreen extends StatefulWidget {
  const AgendarHorarioScreen({super.key});

  @override
  State<AgendarHorarioScreen> createState() => _AgendarHorarioScreenState();
}

class _AgendarHorarioScreenState extends State<AgendarHorarioScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).getListaServicos();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
  }

  final numberControler = TextEditingController();
  final nomeClienteControler = TextEditingController();

  bool verServicos = true;
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
    DateTime? dataSelectedInModal;
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
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
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
                          controller: nomeClienteControler,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
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
                                        Provider.of<Getsdeinformacoes>(context,
                                                listen: false)
                                            .getListaServicos();
                                        Provider.of<Getsdeinformacoes>(context,
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
                                          color: Dadosgeralapp().primaryColor,
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
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${servicoItem.name} - ",
                                                    style: GoogleFonts.openSans(
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
                                                              .green.shade600,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        child: Icon(
                                                          Icons.paid,
                                                          size: 12,
                                                          color: Color.fromRGBO(
                                                              54, 54, 54, 1),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        "R\$${servicoItem.price.toStringAsFixed(2).replaceAll('.', ',')}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color:
                                                                Colors.white38,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Icon(
                                                _selectedIndexService == index
                                                    ? Icons.toggle_on
                                                    : Icons.toggle_off,
                                                size: 40,
                                                color: _selectedIndexService ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.grey.shade600,
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
                    stream:
                        Provider.of<Getsdeinformacoes>(context, listen: false)
                            .getProfissionais,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                    setState(() {
                                      _selectedIndex = isSelected
                                          ? -1
                                          : index; // Atualiza para -1 se já estiver selecionado
                                    });
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
                                            listaBarbeiros[index].urlImageFoto,
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
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: ShowModalData,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                           dataSelectedInModal != null ?  DateFormat("dd/MM/yyyy").format(dataSelectedInModal!): "Clique para escolher",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
