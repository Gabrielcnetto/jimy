import 'package:flutter/material.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/Configuracoes.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/HeaderNomeMaisFoto.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/RankingProfissionais.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/ShoppingParaGerente.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/bannerAnuncios.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/indicadoresQuadro.dart';
import 'package:provider/provider.dart';

class IndicadoresScreen extends StatelessWidget {
  const IndicadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Getsdeinformacoes(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderNomeMaisFoto(),
                  IndicadoresQuadroView(),
                  BannerAnunciosPerfilGerente(),
                  ConfiguracoeswidgetsSet(),
                  RankingProfissionaisHomeGerente(),
                  ShoppingParaGerente(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
