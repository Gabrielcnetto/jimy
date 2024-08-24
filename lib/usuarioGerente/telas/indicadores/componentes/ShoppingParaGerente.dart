import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';

class ShoppingParaGerente extends StatelessWidget {
  const ShoppingParaGerente({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.shopping_cart,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Shopping do Barbeiro",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.orangeAccent,
          )
        ],
      ),
    );
  }
}
