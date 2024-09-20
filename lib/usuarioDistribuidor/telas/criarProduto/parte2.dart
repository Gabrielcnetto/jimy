import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Parte2 extends StatefulWidget {
  final Function(bool)isUsado;
  final Function(bool)parte2ok;
  const Parte2({super.key,required this.isUsado,required this.parte2ok,});

  @override
  State<Parte2> createState() => _Parte2State();
}



class _Parte2State extends State<Parte2> {
  bool isUsado = false;
  void modiFyisUsado(){
    setState(() {
      isUsado = !isUsado;
      widget.isUsado(isUsado);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Qual a condição deste produto?",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: modiFyisUsado,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(isUsado == true
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Usado",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: modiFyisUsado,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Icon(isUsado == false
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Novo",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
