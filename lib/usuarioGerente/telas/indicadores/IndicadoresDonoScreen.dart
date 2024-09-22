import 'package:flutter/material.dart';
import 'package:fiotrim/usuarioGerente/classes/barbeiros.dart';
import 'package:fiotrim/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/Configuracoes.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/HeaderNomeMaisFoto.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/RankingProfissionais.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/ShoppingParaGerente.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/bannerAnuncios.dart';
import 'package:fiotrim/usuarioGerente/telas/indicadores/componentes/indicadoresQuadro.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                child: HeaderNomeMaisFoto(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: IndicadoresQuadroView(),
              ),
              BannerAnunciosPerfilGerente(),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: ConfiguracoeswidgetsSet(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: RankingProfissionaisHomeGerente(),
              ),
             // Padding(
             //   padding: const EdgeInsets.only(left: 15,right: 15),
             //   child: ShoppingParaGerente(),
             // ),
            ],
          ),
        ),
      ),
    );
  }
}
