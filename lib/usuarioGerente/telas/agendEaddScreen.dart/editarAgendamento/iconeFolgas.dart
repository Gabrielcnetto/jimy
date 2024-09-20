import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:provider/provider.dart';

class IconeFolga extends StatefulWidget {
  final Function(bool) functionsBool;
  final DateTime date;
  IconeFolga({
    super.key,
    required this.date,
    required this.functionsBool,
  });

  @override
  State<IconeFolga> createState() => _IconeFolgaState();
}

class _IconeFolgaState extends State<IconeFolga> {
  Future<void> removeFolgOnIntem() async {
    Navigator.of(context).pop();
    setState(() {
      widget.functionsBool(true);
    });
    try {
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .removefolga(
        dateDelete: widget.date,
      );
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .loadFolgas();
      setState(() {
        widget.functionsBool(false);
      });
    } catch (e) {
      setState(() {
        widget.functionsBool(false);
      });
      print("no widget de remover a folga ocorreu um erro:$e");
    }
  }

  void ConfirmExclusao() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Remover Folga?",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          content: Text(
            "Este dia será removido e a data reativada para os clientes",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black45,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar ",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: removeFolgOnIntem,
              child: Text(
                "Remover Folga ",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Dadosgeralapp().primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey.shade100,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Dadosgeralapp().tertiaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.today,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inatividade Configurada",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${DateFormat("dd/MM/yyyy").format(widget.date)}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: ConfirmExclusao,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
