import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/Despesa.dart';
import 'package:Dimy/usuarioGerente/funcoes/despesas.dart';
import 'package:Dimy/usuarioGerente/telas/cadastrarDespesa/componentes/itemPagoViewDespesa.dart';
import 'package:Dimy/usuarioGerente/telas/cadastrarDespesa/componentes/itemVisualDespesa.dart';
import 'package:provider/provider.dart';

class HistoricoCompletoDeSaidas extends StatefulWidget {
  const HistoricoCompletoDeSaidas({super.key});

  @override
  State<HistoricoCompletoDeSaidas> createState() =>
      _HistoricoCompletoDeSaidasState();
}

class _HistoricoCompletoDeSaidasState extends State<HistoricoCompletoDeSaidas> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<DespesasFunctions>(context, listen: false)
          .getDespesaListPosPaga,
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
          listaDespesa.sort((a, b) {
            // Verifica se ambas as despesas possuem histórico de pagamentos
            if (a.historicoPagamentos.isNotEmpty &&
                b.historicoPagamentos.isNotEmpty) {
              // Pega o pagamento mais recente (última data) de cada lista e compara
              DateTime historicoA = a.historicoPagamentos.last;
              DateTime historicoB = b.historicoPagamentos.last;

              return historicoB.compareTo(
                  historicoA); // Ordem decrescente (mais recente primeiro)
            } else if (a.historicoPagamentos.isNotEmpty) {
              // Se apenas 'a' tem histórico, ele deve vir antes de 'b'
              return -1;
            } else if (b.historicoPagamentos.isNotEmpty) {
              // Se apenas 'b' tem histórico, ele deve vir antes de 'a'
              return 1;
            } else {
              // Se ambos estão vazios, mantém a ordem original
              return 0;
            }
          });
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listaDespesa.map(
                (item) {
                  return itemVisualPagoListaGeralDespesa(
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
