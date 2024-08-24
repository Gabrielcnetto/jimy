import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';

class HeaderNomeMaisFoto extends StatefulWidget {
  const HeaderNomeMaisFoto({super.key});

  @override
  State<HeaderNomeMaisFoto> createState() => _HeaderNomeMaisFotoState();
}

class _HeaderNomeMaisFotoState extends State<HeaderNomeMaisFoto> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    funcoes();
  }

  void funcoes() {
    loaduserImageURL();
    loaduserNomeBarbearua();
    loaduserName();
  }

  String? userImageURL;
  Future<void> loaduserImageURL() async {
    String? urldb = await Getsdeinformacoes().getUserURLImage();

    setState(() {
      userImageURL = urldb;
    });
  }

  String? BarbeariaNome;
  Future<void> loaduserNomeBarbearua() async {
    String? nomeBarbearia = await Getsdeinformacoes().getNomeBarbearia();

    setState(() {
      BarbeariaNome = nomeBarbearia;
    });
  }

  String? userName;
  Future<void> loaduserName() async {
    String? nomeBarbearia = await Getsdeinformacoes().getNomeProfissional();

    setState(() {
      userName = nomeBarbearia;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                userImageURL ?? Dadosgeralapp().defaultAvatarImage,
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.18,
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  BarbeariaNome ?? "Carregando...",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  userName ?? "Carregando...",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
