import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/classes/barbeiros.dart';
import 'package:friotrim/usuarioGerente/classes/horarios.dart';
import 'package:friotrim/usuarioGerente/classes/pagamentos.dart';
import 'package:friotrim/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:friotrim/usuarioGerente/telas/EditarHorarios/EditarHorariosPrincipalScreen.dart';
import 'package:friotrim/usuarioGerente/telas/minhaPagina/components/bannerItem.dart';
import 'package:friotrim/usuarioGerente/telas/minhaPagina/components/profItemDaLista.dart';
import 'package:friotrim/usuarioGerente/telas/minhaPagina/editarPerfil/EditarPerfilScreen.dart';
import 'package:friotrim/usuarioGerente/telas/minhaPagina/editarWallpapers/editarWallpapers.dart';
import 'package:provider/provider.dart';

class VisaoGeralMinhaPagina extends StatefulWidget {
  const VisaoGeralMinhaPagina({super.key});

  @override
  State<VisaoGeralMinhaPagina> createState() => _VisaoGeralMinhaPaginaState();
}

class _VisaoGeralMinhaPaginaState extends State<VisaoGeralMinhaPagina> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     Provider.of<Getsdeinformacoes>(context, listen: false)
          .loadBanners();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
    Provider.of<Getsdeinformacoes>(context, listen: false).loadHorariosSemana();

    Provider.of<Getsdeinformacoes>(context, listen: false).loadHorariosSabado();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .loadHorariosDomingo();
    loaduserNomeBarbearua();
    loaduseBarberDescription();
    getFormasPagamentoComoObjetos();
    loaduseBarberStreetAndNumberAndBairro();
    loaduseBarberCity();
    loaduseBarberCEP();
    loadavaliacaoGeralDB();
  }

  List<String> _images = [
    "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/bannerFixo%2FdefaultBanner.jpeg?alt=media&token=b3d110b2-2b3f-4b6c-a67d-4ddb3a327724",
  ];

  String? BarbeariaNome;
  Future<void> loaduserNomeBarbearua() async {
    String? nomeBarbearia = await Getsdeinformacoes().getNomeBarbearia();

    setState(() {
      BarbeariaNome = nomeBarbearia;
    });
  }

  String? enderecoRuaemais;
  Future<void> loaduseBarberStreetAndNumberAndBairro() async {
    String? descData = await Getsdeinformacoes().getEnderecobarbearia();

    setState(() {
      if (descData != null) {
        enderecoRuaemais = descData;
      } else {}
    });
  }

  String? cidadeBarbearia;
  Future<void> loaduseBarberCity() async {
    String? descData = await Getsdeinformacoes().getCidadebarbearia();

    setState(() {
      if (descData != null) {
        cidadeBarbearia = descData;
      }
    });
  }

  String? cepBarbearia;
  Future<void> loaduseBarberCEP() async {
    String? descData = await Getsdeinformacoes().getCEPbarbearia();

    setState(() {
      if (descData != null) {
        cepBarbearia = descData;
      }
    });
  }

  String descricaoBarbearia = "";
  Future<void> loaduseBarberDescription() async {
    String? descData = await Getsdeinformacoes().getDescricaoBarbearia();

    setState(() {
      if (descData != null) {
        descricaoBarbearia = descData;
      }
    });
  }

  List<Pagamentos> listaInicialDB = [];
  Future<void> getFormasPagamentoComoObjetos() async {
    try {
      // Obtém a lista de mapas da função getFormasPagamento()
      List<Map<String, dynamic>> formasPagamentoMap =
          await Editprofilebarberpage().getFormasPagamento();

      // Converte a lista de mapas para uma lista de objetos Pagamentos
      List<Pagamentos> formasPagamento =
          formasPagamentoMap.map((map) => Pagamentos.fromMap(map)).toList();
      print("estou aqui no convert");
      print("${formasPagamento.toList()}");
      setState(() {
        listaInicialDB = formasPagamento;
      });
    } catch (e) {
      setState(() {
        listaInicialDB = [];
      });
      print("Erro ao converter formas de pagamento: $e");
      throw e;
    }
  }

  int avaliacaoGeralDB = 0;
  Future<void> loadavaliacaoGeralDB() async {
    int? valor = await Getsdeinformacoes().getAvaliacaoGeral();

    setState(() {
      avaliacaoGeralDB = valor!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: Provider.of<Getsdeinformacoes>(context, listen: false)
                    .bannersStream,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Dadosgeralapp().primaryColor,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return BannerItem(
                      images: _images,
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return BannerItem(
                      images: _images,
                    );
                  }
                  if (snapshot.hasData) {
                    List<String> bannerList = snapshot.data as List<String>;
                    return BannerItem(
                      images: bannerList,
                    );
                  }
                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "${BarbeariaNome ?? "Carregando..."}",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.verified,
                                color: Colors.blue.shade600,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Este widget exibe as estrelas dinamicamente
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < avaliacaoGeralDB
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 18,
                                    color: Colors.yellow.shade600,
                                  );
                                }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  avaliacaoGeralDB
                                      .toInt()
                                      .toString(), // Exibe o valor inteiro da avaliação
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => EditarPerfilScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Dadosgeralapp().primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Text(
                              "Editar perfil",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          height: 1,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Profissionais disponíveis",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: StreamBuilder(
                                stream: Provider.of<Getsdeinformacoes>(context,
                                        listen: false)
                                    .getProfissionais,
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
                                    return Center(
                                      child: Text(
                                        "Sem profissionais",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    List<Barbeiros> _barberList =
                                        snapshot.data as List<Barbeiros>;
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: _barberList.map((barber) {
                                          return ProfItemDaLista(
                                            barber: barber,
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          height: 1,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Descrição da Barbearia:",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "${descricaoBarbearia ?? "Carregando..."}",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black38, fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Horários de funcionamento",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //segunda
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Segunda-Feira",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: StreamBuilder<List<Horarios>>(
                                            stream:
                                                Provider.of<Getsdeinformacoes>(
                                                        context,
                                                        listen: false)
                                                    .getHorariosSemana,
                                            builder: (ctx, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Dadosgeralapp()
                                                        .primaryColor,
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Erro ao carregar dados',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                final horariosSegunda =
                                                    snapshot.data!;

                                                // Filtrando os horários ativos
                                                final horariosAtivos =
                                                    horariosSegunda
                                                        .where((item) =>
                                                            item.isActive)
                                                        .toList();

                                                final horariosAtivosLength =
                                                    horariosAtivos.length;

                                                // Verificar se a lista de horários ativos está vazia
                                                if (horariosAtivos.isEmpty) {
                                                  return Text(
                                                    "Fechado",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Acessando o primeiro e o último horário da lista filtrada
                                                final primeiroHorario =
                                                    horariosAtivos[0].horario;
                                                final ultimoHorario =
                                                    horariosAtivos[
                                                            horariosAtivosLength -
                                                                1]
                                                        .horario;

                                                return Text(
                                                  "$primeiroHorario - $ultimoHorario",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }

// Caso contrário, retorna um widget padrão
                                              return Container();
                                            }))
                                  ],
                                ),
                                //terca feira
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Terça-Feira",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: StreamBuilder<List<Horarios>>(
                                            stream:
                                                Provider.of<Getsdeinformacoes>(
                                                        context,
                                                        listen: false)
                                                    .getHorariosSemana,
                                            builder: (ctx, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Dadosgeralapp()
                                                        .primaryColor,
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Erro ao carregar dados',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                final horariosSegunda =
                                                    snapshot.data!;

                                                // Filtrando os horários ativos
                                                final horariosAtivos =
                                                    horariosSegunda
                                                        .where((item) =>
                                                            item.isActive)
                                                        .toList();

                                                final horariosAtivosLength =
                                                    horariosAtivos.length;

                                                // Verificar se a lista de horários ativos está vazia
                                                if (horariosAtivos.isEmpty) {
                                                  return Text(
                                                    "Fechado",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Acessando o primeiro e o último horário da lista filtrada
                                                final primeiroHorario =
                                                    horariosAtivos[0].horario;
                                                final ultimoHorario =
                                                    horariosAtivos[
                                                            horariosAtivosLength -
                                                                1]
                                                        .horario;

                                                return Text(
                                                  "$primeiroHorario - $ultimoHorario",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }

// Caso contrário, retorna um widget padrão
                                              return Container();
                                            }))
                                  ],
                                ),
                                //quarta
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Quarta-Feira",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: StreamBuilder<List<Horarios>>(
                                            stream:
                                                Provider.of<Getsdeinformacoes>(
                                                        context,
                                                        listen: false)
                                                    .getHorariosSemana,
                                            builder: (ctx, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Dadosgeralapp()
                                                        .primaryColor,
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Erro ao carregar dados',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                final horariosSegunda =
                                                    snapshot.data!;

                                                // Filtrando os horários ativos
                                                final horariosAtivos =
                                                    horariosSegunda
                                                        .where((item) =>
                                                            item.isActive)
                                                        .toList();

                                                final horariosAtivosLength =
                                                    horariosAtivos.length;

                                                // Verificar se a lista de horários ativos está vazia
                                                if (horariosAtivos.isEmpty) {
                                                  return Text(
                                                    "Fechado",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Acessando o primeiro e o último horário da lista filtrada
                                                final primeiroHorario =
                                                    horariosAtivos[0].horario;
                                                final ultimoHorario =
                                                    horariosAtivos[
                                                            horariosAtivosLength -
                                                                1]
                                                        .horario;

                                                return Text(
                                                  "$primeiroHorario - $ultimoHorario",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }

// Caso contrário, retorna um widget padrão
                                              return Container();
                                            }))
                                  ],
                                ),
                                //quinta
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Quinta-Feira",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: StreamBuilder<List<Horarios>>(
                                            stream:
                                                Provider.of<Getsdeinformacoes>(
                                                        context,
                                                        listen: false)
                                                    .getHorariosSemana,
                                            builder: (ctx, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Dadosgeralapp()
                                                        .primaryColor,
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Erro ao carregar dados',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                final horariosSegunda =
                                                    snapshot.data!;

                                                // Filtrando os horários ativos
                                                final horariosAtivos =
                                                    horariosSegunda
                                                        .where((item) =>
                                                            item.isActive)
                                                        .toList();

                                                final horariosAtivosLength =
                                                    horariosAtivos.length;

                                                // Verificar se a lista de horários ativos está vazia
                                                if (horariosAtivos.isEmpty) {
                                                  return Text(
                                                    "Fechado",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Acessando o primeiro e o último horário da lista filtrada
                                                final primeiroHorario =
                                                    horariosAtivos[0].horario;
                                                final ultimoHorario =
                                                    horariosAtivos[
                                                            horariosAtivosLength -
                                                                1]
                                                        .horario;

                                                return Text(
                                                  "$primeiroHorario - $ultimoHorario",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }

// Caso contrário, retorna um widget padrão
                                              return Container();
                                            }))
                                  ],
                                ),
                                //sexta
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sexta-Feira",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: StreamBuilder<List<Horarios>>(
                                            stream:
                                                Provider.of<Getsdeinformacoes>(
                                                        context,
                                                        listen: false)
                                                    .getHorariosSemana,
                                            builder: (ctx, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Dadosgeralapp()
                                                        .primaryColor,
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Erro ao carregar dados',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                final horariosSegunda =
                                                    snapshot.data!;

                                                // Filtrando os horários ativos
                                                final horariosAtivos =
                                                    horariosSegunda
                                                        .where((item) =>
                                                            item.isActive)
                                                        .toList();

                                                final horariosAtivosLength =
                                                    horariosAtivos.length;

                                                // Verificar se a lista de horários ativos está vazia
                                                if (horariosAtivos.isEmpty) {
                                                  return Text(
                                                    "Fechado",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Acessando o primeiro e o último horário da lista filtrada
                                                final primeiroHorario =
                                                    horariosAtivos[0].horario;
                                                final ultimoHorario =
                                                    horariosAtivos[
                                                            horariosAtivosLength -
                                                                1]
                                                        .horario;

                                                return Text(
                                                  "$primeiroHorario - $ultimoHorario",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }

// Caso contrário, retorna um widget padrão
                                              return Container();
                                            }))
                                  ],
                                ),
                                //sabado
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sábado",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: StreamBuilder<List<Horarios>>(
                                        stream: Provider.of<Getsdeinformacoes>(
                                                context,
                                                listen: false)
                                            .getHorariosSabado,
                                        builder: (ctx, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Dadosgeralapp()
                                                    .primaryColor,
                                              ),
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'Erro ao carregar dados',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            final horariosSabado =
                                                snapshot.data!;

                                            // Filtrando os horários ativos
                                            final horariosAtivos =
                                                horariosSabado
                                                    .where(
                                                        (item) => item.isActive)
                                                    .toList();

                                            final horariosAtivosLength =
                                                horariosAtivos.length;

                                            // Verifica se a lista filtrada está vazia
                                            if (horariosAtivos.isEmpty) {
                                              return Text(
                                                "Fechado",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            }

                                            // Acessando o primeiro e o último horário da lista filtrada
                                            final primeiroHorario =
                                                horariosAtivos[0].horario;
                                            final ultimoHorario =
                                                horariosAtivos[
                                                        horariosAtivosLength -
                                                            1]
                                                    .horario;

                                            return Text(
                                              "$primeiroHorario - $ultimoHorario",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }
                                          // Caso contrário, retorna um widget padrão
                                          return Container();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                //domingo
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Domingo",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: StreamBuilder<List<Horarios>>(
                                        stream: Provider.of<Getsdeinformacoes>(
                                                context,
                                                listen: false)
                                            .getHorariosDomingo,
                                        builder: (ctx, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Dadosgeralapp()
                                                    .primaryColor,
                                              ),
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'Erro ao carregar dados',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            final horariosDomingo =
                                                snapshot.data!;

                                            // Filtrando os horários ativos
                                            final horariosAtivos =
                                                horariosDomingo
                                                    .where(
                                                        (item) => item.isActive)
                                                    .toList();

                                            final horariosAtivosLength =
                                                horariosAtivos.length;

                                            // Verifica se a lista filtrada está vazia
                                            if (horariosAtivos.isEmpty) {
                                              return Text(
                                                "Fechado",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            }

                                            // Acessando o primeiro e o último horário da lista filtrada
                                            final primeiroHorario =
                                                horariosAtivos[0].horario;
                                            final ultimoHorario =
                                                horariosAtivos[
                                                        horariosAtivosLength -
                                                            1]
                                                    .horario;

                                            return Text(
                                              "$primeiroHorario - $ultimoHorario",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          }
                                          // Caso contrário, retorna um widget padrão
                                          return Container();
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          EditarHorariosPrincipalEscreen()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Dadosgeralapp().primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    child: Text(
                                      "Alterar horários",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Formas de pagamento",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Na Barbearia:",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: listaInicialDB.map((item) {
                                        return Container(
                                          width: 15,
                                          height: 15,
                                          child: Image.network(
                                            item.photoIcon,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (ctx) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.6,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.elliptical(
                                                        20, 20),
                                                    topRight: Radius.elliptical(
                                                        20, 20)),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              height: 5,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.15),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Formas de pagamento",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Pagamento na barbearia",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.35,
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            childAspectRatio: 5,
                                                            crossAxisCount:
                                                                2, // Número de colunas
                                                            crossAxisSpacing:
                                                                10.0, // Espaçamento horizontal entre colunas
                                                            mainAxisSpacing:
                                                                10.0, // Espaçamento vertical entre linhas
                                                          ),
                                                          itemCount:
                                                              listaInicialDB
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final pagamento =
                                                                listaInicialDB[
                                                                    index];
                                                            return Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          15),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: 20,
                                                                    height: 20,
                                                                    child: Image
                                                                        .network(
                                                                      pagamento
                                                                          .photoIcon,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      pagamento
                                                                          .name,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black45,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Endereço",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${enderecoRuaemais ?? "Sem endereço"}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                ),
                                Text(
                                  "${cidadeBarbearia ?? "Sem Cidade"}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                ),
                                Text(
                                  "CEP: ${cepBarbearia ?? "Sem CEP"}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
