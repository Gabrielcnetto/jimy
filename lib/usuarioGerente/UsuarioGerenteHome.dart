import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/funcoes/CriarContaeLogar.dart';
import 'package:Dimy/rotas/confirmacaoAgendamento.dart';
import 'package:Dimy/rotas/verificadorDeLogin.dart';
import 'package:Dimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/telas/agendEaddScreen.dart/agendaEAddScreen.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/IndicadoresDonoScreen.dart';
import 'package:Dimy/usuarioGerente/telas/minhaPagina/visaoGeralMinhaPagina.dart';
import 'package:Dimy/usuarioGerente/telas/visaoAvancadaIndicadores/novaInternoIndicadores.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsuarioGerenteHome extends StatefulWidget {
  final int indexTela;
  const UsuarioGerenteHome({
    super.key,
    required this.indexTela,
  });

  @override
  State<UsuarioGerenteHome> createState() => _UsuarioGerenteHomeState();
}

class _UsuarioGerenteHomeState extends State<UsuarioGerenteHome> {
  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startIndex();
    _screensSelect = [
      {
        'tela': IndicadoresScreen(),
      },
      {
        'tela': AgendaEAddScreen(),
      },
      {
        'tela': InternoIndicadoresScreenV2(),
      },
      {
        'tela': VisaoGeralMinhaPagina(),
      },
    ];
  }

  void startIndex() {
    setState(() {
      screen = widget.indexTela;
      currentIndex = widget.indexTela;
    });
  }

  int currentIndex = 0; // Índice do item atual

  void attScren(int index) {
    setState(() {
      currentIndex = index;
      screen = index; // Atualiza a tela com base no índice selecionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screensSelect![screen]['tela'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: attScren,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 11),
        ),
        unselectedItemColor: Colors.black38,
        unselectedLabelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.black45,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Ínicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: "Agenda",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics,
            ),
            label: "Análise",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.storefront,
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
