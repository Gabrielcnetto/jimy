import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/funcoes/CriarContaeLogar.dart';
import 'package:jimy/rotas/confirmacaoAgendamento.dart';
import 'package:jimy/rotas/verificadorDeLogin.dart';
import 'package:jimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/agendaEAddScreen.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/IndicadoresDonoScreen.dart';
import 'package:provider/provider.dart';

class UsuarioGerenteHome extends StatefulWidget {
  const UsuarioGerenteHome({
    super.key,
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

    _screensSelect = [
      {
        'tela': IndicadoresScreen(),
      },
      {
        'tela': Container(),
      },
      {
        'tela': AgendaEAddScreen(),
      },
      {
        'tela': Container(),
      },
      {
        'tela': Container(),
      },
    ];
  }

  void attScren(int index) {
    setState(() {
      screen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screensSelect![screen]['tela'] as Widget,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: CurvedNavigationBar(
          height: 55,
          animationDuration: const Duration(milliseconds: 80),
          onTap: attScren,
          index: screen,
          backgroundColor: Dadosgeralapp().primaryColor,
          items: [
            const Icon(
              Icons.home,
              size: 25,
            ),
            const Icon(
              Icons.play_circle,
              size: 25,
            ),
            const Icon(
              Icons.calendar_today,
              size: 25,
            ),
            const Icon(
              Icons.shopping_cart,
              size: 25,
            ),
            const Icon(
              Icons.storefront,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
