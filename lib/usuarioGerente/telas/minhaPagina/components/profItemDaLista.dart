import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/usuarioGerente/classes/barbeiros.dart';

class ProfItemDaLista extends StatelessWidget {
  final Barbeiros barber;
  const ProfItemDaLista({
    super.key,
    required this.barber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.22,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                barber.urlImageFoto,
                 fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              barber.name,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
