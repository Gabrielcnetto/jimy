import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/comanda.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/telas/visaoAvancadaIndicadores/itemComandaMesSelecionado.dart';
import 'package:provider/provider.dart';

class TelaClientesMesSelecionado extends StatefulWidget {
  final String mesSelecionado;
  final int AnoSelecionado;
  const TelaClientesMesSelecionado({
    super.key,
    required this.mesSelecionado,
    required this.AnoSelecionado,
  });

  @override
  State<TelaClientesMesSelecionado> createState() =>
      _TelaClientesMesSelecionadoState();
}

class _TelaClientesMesSelecionadoState
    extends State<TelaClientesMesSelecionado> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .loadComandasMesSelecionado(
      mesSelecionado: widget.mesSelecionado,
      year: widget.AnoSelecionado,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                              color: Dadosgeralapp().primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Seus clientes em ${widget.mesSelecionado}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: StreamBuilder(
                    stream:
                        Provider.of<Getsdeinformacoes>(context, listen: false)
                            .comandaListStream,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Dadosgeralapp().primaryColor,
                          ),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Sem clientes atendidos em ${widget.mesSelecionado}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        List<Comanda> _listaComandaSnap =
                            snapshot.data as List<Comanda>;
                          _listaComandaSnap.sort((a,b)=>b.dataFinalizacao.compareTo(a.dataFinalizacao));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _listaComandaSnap.map((item){
                            return ItemComandaMesSelecionado(comanda: item,);
                          }).toList(),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
