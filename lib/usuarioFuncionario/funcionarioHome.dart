import 'package:fiotrim/usuarioFuncionario/IndicadoresDonoScreen.dart';
import 'package:fiotrim/usuarioFuncionario/agendaEAddScreen.dart';
import 'package:fiotrim/usuarioGerente/telas/agendEaddScreen.dart/agendaEAddScreen.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/IndicadoresDonoScreen.dart';
import 'package:fiotrim/usuarioGerente/telas/minhaPagina/visaoGeralMinhaPagina.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/novaInternoIndicadores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsuarioFuncionarioHome extends StatefulWidget {
  const UsuarioFuncionarioHome({super.key});

  @override
  State<UsuarioFuncionarioHome> createState() => _UsuarioFuncionarioHomeState();
}

class _UsuarioFuncionarioHomeState extends State<UsuarioFuncionarioHome> {
    int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _screensSelect = [
      {
        'tela': IndicadoresScreenFuncionario(),
      },
      {
        'tela': AgendaEAddScreenFuncionarioView(),
      },
    
    
    ];
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
        
         
        ],
      ),
    );
  }
}
