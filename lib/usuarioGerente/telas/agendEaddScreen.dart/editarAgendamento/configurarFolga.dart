import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:friotrim/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/iconeFolgas.dart';
import 'package:provider/provider.dart';

class ConfigurarFolga extends StatefulWidget {
  const ConfigurarFolga({super.key});

  @override
  State<ConfigurarFolga> createState() => _ConfigurarFolgaState();
}

class _ConfigurarFolgaState extends State<ConfigurarFolga> {
  DateTime? dateSelecionado;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Editprofilebarberpage>(context, listen: false).loadFolgas();
  }

  bool isLoading = false;
  void addDayOnDatetime() {
    setState(() {
      dateSelecionado = null;
    });
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime(2090),
      selectableDayPredicate: (DateTime day) {
        return true;
      },
    ).then((selectUserDate) {
      try {
        if (selectUserDate != null) {
          setState(() {
            dateSelecionado = selectUserDate;
            functionsAddOnDbDataSelecionada();
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

  Future<void> functionsAddOnDbDataSelecionada() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Editprofilebarberpage>(context, listen: false).setFolga(
        date: dateSelecionado!,
      );
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .loadFolgas();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Ao adicionar a data deu este erro:$e");
    }
  }

  void getBool(bool bool){
    setState(() {
      isLoading = bool;
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                              color: Dadosgeralapp().primaryColor,
                            ),
                          ),
                          Text(
                            "Inatividades configuradas",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: addDayOnDatetime,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Dadosgeralapp().primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Envie um dia",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey.shade100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: StreamBuilder(
                            stream: Provider.of<Editprofilebarberpage>(context,
                                    listen: false)
                                .folgasStream,
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Dadosgeralapp().primaryColor,
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Houve um erro..."),
                                );
                              }
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "Sem folgas configuradas",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.hasData) {
                                List<DateTime> datetimeList =
                                    snapshot.data as List<DateTime>;
                                    datetimeList.sort((a,b)=>b.day.compareTo(a.day));
                                return Column(
                                  children: datetimeList.map((item) {
                                    return IconeFolga(
                                      functionsBool: getBool,
                                      date: item,
                                    );
                                  }).toList(),
                                );
                              }
                              return Container();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading == true) ...[
                Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
