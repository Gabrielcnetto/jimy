import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/classes/servico.dart';
import 'package:friotrim/usuarioGerente/funcoes/CriarServicos.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class ItemViewGeralServico extends StatefulWidget {
  final Servico service;
  const ItemViewGeralServico({
    super.key,
    required this.service,
  });

  @override
  State<ItemViewGeralServico> createState() => _ItemViewGeralServicoState();
}

class _ItemViewGeralServicoState extends State<ItemViewGeralServico> {
  void showAndRemove() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Remover serviço?",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            content: Text(
              "Este serviço será removido da sua barbearia. Se o intuito é editar, remova este e crie um novo com as novas informações",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: removerDb,
                child: Text(
                  "Remover",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Dadosgeralapp().primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> removerDb() async {
    try {
      Navigator.of(context).pop();
      await Provider.of<Criarservicos>(context, listen: false).removerServico(
        service: widget.service,
      );
      await Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaServicos();
    } catch (e) {
      print("Houve um erro ao remover o serviço:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    "${widget.service.name}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tempo estimado: ",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        widget.service.ocupar2vagas == true
                            ? "60 Minutos"
                            : "30 Minutos",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "R\$${widget.service.price.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: showAndRemove,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
