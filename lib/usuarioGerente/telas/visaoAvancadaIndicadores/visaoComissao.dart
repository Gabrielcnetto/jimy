import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/usuarioGerente/classes/barbeiros.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class ItemVisaoComissao extends StatefulWidget {
  final int anoDeBusca;
  final String mesDeBusca;
  final Barbeiros barbeiro;
  const ItemVisaoComissao({
    super.key,
    required this.barbeiro,
    required this.anoDeBusca,
    required this.mesDeBusca,
  });

  @override
  State<ItemVisaoComissao> createState() => _ItemVisaoComissaoState();
}

class _ItemVisaoComissaoState extends State<ItemVisaoComissao> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadComissaoDoMes();
  }

  
  double valorDaComissao = 0;
  Future<void> loadComissaoDoMes() async {
    double? valor = await Provider.of<Getsdeinformacoes>(context, listen: false)
        .getComissaoDoBarbeiroPeloMesInterno(
      anoDaBusca: widget.anoDeBusca,
      barbeiroId: widget.barbeiro.id,
      mesSelecionado: widget.mesDeBusca,
    );
    setState(() {
      valorDaComissao = valor!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(10, 10),
              bottomRight: Radius.elliptical(10, 10)),
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ClipRRect(
                    child: Image.network(
                      widget.barbeiro.urlImageFoto,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.barbeiro.name,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "% recebida por cortes:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.barbeiro.porcentagemCortes.toStringAsFixed(0)}%",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Container(
              child: Text(
                "R\$${valorDaComissao.toStringAsFixed(2).replaceAll('.', ',')}",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            ),
          ],
        ),
      ),
    );
  }
}
