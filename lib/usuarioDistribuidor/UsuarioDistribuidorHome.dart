import 'package:flutter/material.dart';
import 'package:friotrim/funcoes/CriarContaeLogar.dart';
import 'package:friotrim/rotas/verificadorDeLogin.dart';
import 'package:friotrim/usuarioDistribuidor/telas/produtosAdicionados/telaProdutosAdicionados.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsuarioGerenteDistribuidor extends StatefulWidget {
  const UsuarioGerenteDistribuidor({super.key});

  @override
  State<UsuarioGerenteDistribuidor> createState() =>
      _UsuarioGerenteDistribuidorState();
}

class _UsuarioGerenteDistribuidorState
    extends State<UsuarioGerenteDistribuidor> {
  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _screensSelect = [
      {
        'tela': Container(),
      },
      {
        'tela': TelaProdutosAdicionados(),
      },
      {
        'tela': Container(),
      },
      {
        'tela': Container(),
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
              Icons.dashboard,
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2,
            ),
            label: "Produtos",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sell,
            ),
            label: "Vendas",
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
