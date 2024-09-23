import 'package:Dimy/usuarioFuncionario/RankingProfissionais.dart';
import 'package:Dimy/usuarioFuncionario/indicadoresQuadro.dart';
import 'package:flutter/material.dart';
import 'package:Dimy/usuarioGerente/classes/barbeiros.dart';
import 'package:Dimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/Configuracoes.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/HeaderNomeMaisFoto.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/RankingProfissionais.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/ShoppingParaGerente.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/bannerAnuncios.dart';
import 'package:Dimy/usuarioGerente/telas/indicadores/componentes/indicadoresQuadro.dart';
import 'package:provider/provider.dart';

class IndicadoresScreenFuncionario extends StatefulWidget {
  const IndicadoresScreenFuncionario({super.key});

  @override
  State<IndicadoresScreenFuncionario> createState() => _IndicadoresScreenFuncionarioState();
}

class _IndicadoresScreenFuncionarioState extends State<IndicadoresScreenFuncionario> {

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
                child: IndicadoresQuadroViewFuncionario(),
              ),
              BannerAnunciosPerfilGerente(),
             // Padding(
             //   padding: const EdgeInsets.only(left: 15,right: 15),
             //   child: ConfiguracoeswidgetsSet(),
             // ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: RankingProfissionaisHomeFuncionario(),
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
