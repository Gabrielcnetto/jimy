import 'package:flutter/material.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/Configuracoes.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/HeaderNomeMaisFoto.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/RankingProfissionais.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/ShoppingParaGerente.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/bannerAnuncios.dart';
import 'package:jimy/usuarioGerente/telas/indicadores/componentes/indicadoresQuadro.dart';
import 'package:provider/provider.dart';

class IndicadoresScreen extends StatefulWidget {
  const IndicadoresScreen({super.key});

  @override
  State<IndicadoresScreen> createState() => _IndicadoresScreenState();
}

class _IndicadoresScreenState extends State<IndicadoresScreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
      Provider.of<Getsdeinformacoes>(context, listen: false).getListaProfissionais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
