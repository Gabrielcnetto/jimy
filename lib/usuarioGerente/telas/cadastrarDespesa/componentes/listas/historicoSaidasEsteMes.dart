import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/Despesa.dart';
import 'package:Dimy/usuarioGerente/funcoes/despesas.dart';
import 'package:Dimy/usuarioGerente/telas/cadastrarDespesa/componentes/itemVisualDespesa.dart';
import 'package:provider/provider.dart';

class SaidasEsteMes extends StatefulWidget {
  final int mesAtual;
  const SaidasEsteMes({super.key, required this.mesAtual});

  @override
  State<SaidasEsteMes> createState() => _SaidasEsteMesState();
}

class _SaidasEsteMesState extends State<SaidasEsteMes> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Provider.of<DespesasFunctions>(context, listen: false).getDespesaList,
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
              "Nenhuma Despesa criada",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          List<Despesa> listaDespesa = snapshot.data as List<Despesa>;
          List<Despesa> listaDespesaFiltrada = listaDespesa
              .where((atributo) =>
                  atributo.pagoDeInicio == false &&
                  atributo.momentoFinalizacao.month != widget.mesAtual)
              .toList();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listaDespesaFiltrada.map(
                (item) {
                  return ItemVisualDespesa(
                    despesa: item,
                  );
                },
              ).toList(),
            ),
          );
        }
        return Container();
      },
    );
  }
}
