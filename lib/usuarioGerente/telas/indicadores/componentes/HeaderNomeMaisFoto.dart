import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/funcoes/CriarContaeLogar.dart';
import 'package:friotrim/rotas/AppRoutes.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Provider.of<CriarcontaelogarProvider>(context, listen: false)
                  .deslogar();
              Navigator.of(context).pushReplacementNamed(Approutes.VerificacaoDeLogado);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.logout,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
