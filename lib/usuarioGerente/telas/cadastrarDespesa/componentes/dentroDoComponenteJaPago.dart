import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/Despesa.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/funcoes/despesas.dart';
import 'package:provider/provider.dart';

class DentroDoComponenteJaPago extends StatefulWidget {
  final Despesa despesaInfs;
  const DentroDoComponenteJaPago({
    super.key,
    required this.despesaInfs,
  });

  @override
  State<DentroDoComponenteJaPago> createState() =>
      _DentroDoComponenteJaPagoState();
}

class _DentroDoComponenteJaPagoState extends State<DentroDoComponenteJaPago> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
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
                    Container(
                      child: Text(
                        widget.despesaInfs.name,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.14,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Valor:",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            "R\$${widget.despesaInfs.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    //fim do preco, agora container da imagem:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Comprovante enviado ",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                      decoration: BoxDecoration(color: Colors.grey.shade50,borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.despesaInfs.urlImageComprovante,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
