import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/usuarioDistribuidor/telas/criarProduto/parte1.dart';
import 'package:friotrim/usuarioDistribuidor/telas/criarProduto/parte2.dart';
import 'package:friotrim/usuarioDistribuidor/telas/criarProduto/parte3.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaDeCriarOProdutoDistribuidor extends StatefulWidget {
  const TelaDeCriarOProdutoDistribuidor({super.key});

  @override
  State<TelaDeCriarOProdutoDistribuidor> createState() =>
      _TelaDeCriarOProdutoDistribuidorState();
}

class _TelaDeCriarOProdutoDistribuidorState
    extends State<TelaDeCriarOProdutoDistribuidor> {
  bool parte1ok = true;
  bool parte2ok = false;
  bool parte3ok = false;
  List<String> CategoriasSelecionadas = [];
  String marcaSelecionada = "";
  String nomeProduto = "";
  bool isUsado = false;
  List<File> listFiles = [];
  void parte2OkFN(bool parte2ok) {
    setState(() {
      parte2ok = parte2ok;
      parte1ok = false;
    });
  }

  void isUsadoFunction(bool isUsadoBool) {
    setState(() {
      isUsado = isUsadoBool;
    });
  }
  void setParte3(bool parte3){}

  void parte1bool(
    bool bool,
  ) {
    setState(() {
      parte1ok = bool;
      parte2ok = true;
    });
  }

  void parte1Categorias(
    List<String> list,
  ) {
    setState(() {
      CategoriasSelecionadas = list;
    });
  }

  void parte1Marca(
    String marca,
  ) {
    setState(() {
      marcaSelecionada = marca;
    });
  }

  void parte1NomeProduto(
    String nomeProduto,
  ) {
    setState(() {
      nomeProduto = nomeProduto;
    });
  } 
  void getFilesPasso3(List<File>files){
    setState(() {
      listFiles = files;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        "Publicar Produto",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  //parte 1
                  if (parte1ok == true)
                    Parte1Informacoes(
                      parte1ok: parte1bool,
                      categorias: parte1Categorias,
                      marcaProduto: parte1Marca,
                      nomeProduto: parte1NomeProduto,
                    ),
                  if (parte2ok == true)
                    Parte2(
                      parte2ok: parte2OkFN,
                      isUsado: isUsadoFunction,
                    ),
                  if (parte3ok == true) Parte3(files: getFilesPasso3,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
