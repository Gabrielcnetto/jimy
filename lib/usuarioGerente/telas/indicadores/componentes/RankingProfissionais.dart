import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/adicionarProfissional/visaoTodosProfissionais.dart';
import 'package:provider/provider.dart';

class RankingProfissionaisHomeGerente extends StatefulWidget {
  const RankingProfissionaisHomeGerente({
    super.key,
  });

  @override
  State<RankingProfissionaisHomeGerente> createState() =>
      _RankingProfissionaisHomeGerenteState();
}

class _RankingProfissionaisHomeGerenteState
    extends State<RankingProfissionaisHomeGerente> {
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder<List<Barbeiros>>(
          stream: Provider.of<Getsdeinformacoes>(context, listen: false)
              .getProfissionais, // Substitua pelo seu método que retorna o Stream
          builder:
              (BuildContext context, AsyncSnapshot<List<Barbeiros>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Mostra um indicador de carregamento enquanto os dados estão sendo carregados
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Mostra um erro se ocorrer
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Mostra uma mensagem se não houver dados
              return Center(child: Text('Nenhum dado disponível'));
            }

            List<Barbeiros> listaBarbeiros = snapshot.data as List<Barbeiros>;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ranking de Barbeiros",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => VisaoTodosOsProfissionais(),
                            ),
                          );
                        },
                        child: Text(
                          "Ver todos",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Dadosgeralapp().primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Top 2
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          listaBarbeiros[1].urlImageFoto,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Icon(
                                          Icons.workspace_premium,
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "${listaBarbeiros[1].name ?? "erro..."}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Dadosgeralapp()
                                        .secondaryColor
                                        .withOpacity(0.5),
                                  ),
                                  child: Text(
                                    "${listaBarbeiros[1].totalCortes.toStringAsFixed(0) ?? 0} cortes",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height *
                                      0.175,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Dadosgeralapp().secondaryColor,
                                        Colors.white,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.elliptical(8, 8),
                                      topRight: Radius.elliptical(8, 8),
                                    ),
                                  ),
                                  child: Text(
                                    "2",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //fim do barbeiro do ranking 2
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          listaBarbeiros[0].urlImageFoto,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade600,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Icon(
                                          Icons.emoji_events,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "${listaBarbeiros[0].name ?? "erro..."}",
                                   textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Dadosgeralapp()
                                        .primaryColor
                                        .withOpacity(0.8),
                                  ),
                                  child: Text(
                                    "${listaBarbeiros[0].totalCortes.toStringAsFixed(0) ?? 0} cortes",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Dadosgeralapp().primaryColor,
                                        Colors.white,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.elliptical(8, 8),
                                      topRight: Radius.elliptical(8, 8),
                                    ),
                                  ),
                                  child: Text(
                                    "1",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        //top 3
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          listaBarbeiros[2].urlImageFoto,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color:
                                                Dadosgeralapp().tertiaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Icon(
                                          Icons.workspace_premium,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "${listaBarbeiros[2].name ?? "erro..."}",
                                   textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black,
                                  )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Dadosgeralapp()
                                        .tertiaryColor
                                        .withOpacity(0.8),
                                  ),
                                  child: Text(
                                    "${listaBarbeiros[2].totalCortes.toStringAsFixed(0) ?? 0} cortes",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height *
                                      0.130,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Dadosgeralapp().tertiaryColor,
                                        Colors.white,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.elliptical(8, 8),
                                      topRight: Radius.elliptical(8, 8),
                                    ),
                                  ),
                                  child: Text(
                                    "3",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
