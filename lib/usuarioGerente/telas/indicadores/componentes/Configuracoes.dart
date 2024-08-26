import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/telas/adicionarProfissional/adicionarProfissionalScreen.dart';
import 'package:jimy/usuarioGerente/telas/adicionarServicos/adicionarServicosScreen.dart';

class ConfiguracoeswidgetsSet extends StatelessWidget {
  const ConfiguracoeswidgetsSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AdicionarProfissional()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Dadosgeralapp().colorBlackparaFundo,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.badge,
                      size: 22,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        "Cadastre profissionais ",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Acessar",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Dadosgeralapp().secondaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.category,
                      size: 22,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        "Cadastre Produtos",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Acessar",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AdicionarServicosScreen(),
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Dadosgeralapp().primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.point_of_sale,
                      size: 22,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        "Cadastre serviços",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Acessar",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
