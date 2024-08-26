import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/adicionarProfissional/visaointernaProfissionalEdit.dart';
import 'package:provider/provider.dart';

class VisaoTodosOsProfissionais extends StatefulWidget {
  const VisaoTodosOsProfissionais({super.key});

  @override
  State<VisaoTodosOsProfissionais> createState() =>
      _VisaoTodosOsProfissionaisState();
}

class _VisaoTodosOsProfissionaisState extends State<VisaoTodosOsProfissionais> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              color: Dadosgeralapp().primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Profissionais adicionados",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container()
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream:
                          Provider.of<Getsdeinformacoes>(context, listen: false)
                              .getProfissionais,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Barbeiros>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Dadosgeralapp().primaryColor,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Ocorreu um erro"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          Center(
                            child: Text("Sem dados para Exibir"),
                          );
                        }
                        List<Barbeiros> listaBarbeiros =
                            snapshot.data as List<Barbeiros>;
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 10, left: 10),
                          child: Container(
                            child: Column(
                              children: listaBarbeiros.map((item) {
                                return Dismissible(
                                  direction: DismissDirection.endToStart,
                                  key: Key("delete:${item.id}"),
                                  background: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Excluir?",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    VisaoInternaProfissional(
                                                      barber: item,
                                                    )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.grey.shade100
                                                .withOpacity(0.5)),
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: Image.network(
                                                        item.urlImageFoto,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.08,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.name,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      "Porcentagem: ${item.porcentagemCortes.toStringAsFixed(0)}%",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              item.ativoParaClientes
                                                  ? Icons.toggle_on
                                                  : Icons.toggle_off,
                                              size: 40,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
