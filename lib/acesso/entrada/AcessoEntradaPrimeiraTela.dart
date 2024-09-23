import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/acesso/entrada/criacaoClienteNormal/CriarContaNormalScreen.dart';
import 'package:Dimy/acesso/entrada/criacaoDistribuidor/AcessoEntradaDistribuidor.dart';
import 'package:Dimy/acesso/entrada/criacaoDonoBarbearia/AcessoEntradaDonoBarbearia.dart';
import 'package:Dimy/acesso/recuperarSenha/recuperarSenhaScreen.dart';
import 'package:Dimy/funcoes/CriarContaeLogar.dart';
import 'package:Dimy/rotas/verificadorDeLogin.dart';
import 'package:provider/provider.dart';

class AcessoEntrada extends StatefulWidget {
  const AcessoEntrada({super.key});

  @override
  State<AcessoEntrada> createState() => _AcessoEntradaState();
}

class _AcessoEntradaState extends State<AcessoEntrada> {
  bool versenha = true;

  void showModalQuestionaTipoConta() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 70, left: 30, right: 30),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Escolha seu tipo de conta:",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //primeiro options
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => AcessoEntradaDonoBarbearia(),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Dadosgeralapp().primaryColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Tenho uma Barbearia",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                //fim do primeiro options
                SizedBox(
                  height: 15,
                ),
                // InkWell(
                //   onTap: () async {
                //     Navigator.of(context).pop();
                //    Navigator.of(context).push(
                //     MaterialPageRoute(
                //         builder: (ctx) => AcessoEntradaDistribuidorScreen(),
                //       ),
                //     );
                //   },
                //   child: Container(
                //    decoration: BoxDecoration(
                //      borderRadius: BorderRadius.circular(5),
                //      color: Dadosgeralapp().secondaryColor,
                //    ),
                //    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                //    alignment: Alignment.center,
                //   child: Text(
                //    "Distribuidor",
                //     style: GoogleFonts.openSans(
                //        textStyle: TextStyle(
                //     fontWeight: FontWeight.w700,
                //     color: Colors.white,
                //   )),
                //  ),
                // ),
                //  ),
                //fim segundo options
                //   //SizedBox(
                //   height: 15,
                //  ),
                //  InkWell(
                //   onTap: () async {
                //     Navigator.of(context).pop();
                //      Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (ctx) => CriarContaNormalScreen(),
                //      ),
                //     );
                //  },
                //  child: Container(
                //   decoration: BoxDecoration(
                //      borderRadius: BorderRadius.circular(5),
                //     color: Dadosgeralapp().tertiaryColor,
                //  ),
                //  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                //  alignment: Alignment.center,
                //  child: Text(
                //    "Cliente",
                //   style: GoogleFonts.openSans(
                //       textStyle: TextStyle(
                //     fontWeight: FontWeight.w700,
                //     color: Colors.white,
                //   )),
                // ),
                // ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
  //login do usuario

  final emailControler = TextEditingController();
  final senhaControler = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> loginuser() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<CriarcontaelogarProvider>(context, listen: false)
          .userLogin(
        email: emailControler.text,
        password: senhaControler.text,
      );
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        barrierDismissible:
            false, // Evita que o diálogo seja fechado ao tocar fora dele
        builder: (ctx) {
          // Inicia um Timer para fechar o diálogo e redirecionar após 3 segundos
          Timer(Duration(seconds: 3), () {
            Navigator.of(ctx).pop(); // Fecha o diálogo
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VerificacaoDeLogado()),
            );
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Login Realizado!",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ),
            content: Text(
              "Aguarde um instante...",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black45),
              ),
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Dados incorretos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              content: Text(
                "Verifique os dados inseridos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Fechar",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      print("houve um erro");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.width * 0.21,
                                child: Image.asset(
                                  "imagesapp/logopadrao.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            child: Text(
                              "Entrar",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Dadosgeralapp().secundariaColor,
                                fontSize: 35,
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //formularios
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seu e-mail",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.email,
                                    size: 20,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite um e-mail';
                                        }
                                        return null;
                                      },
                                      controller: emailControler,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //senha
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sua senha",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.lock_clock_rounded,
                                    size: 20,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite uma senha';
                                        }
                                        return null;
                                      },
                                      controller: senhaControler,
                                      obscureText: versenha,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        versenha = !versenha;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        versenha == true
                                            ? Icons.remove_red_eye_sharp
                                            : Icons.visibility_off,
                                        size: 20,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => RecuperarSenhaScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Esqueceu a senha?",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Dadosgeralapp().principalColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              loginuser();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Dadosgeralapp().principalColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            child: Text(
                              "Entrar",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "OU",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Primeiro Acesso?",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp()
                                      .cinzaParaSubtitulosOuDescs,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              hoverDuration: Duration(seconds: 0),
                              onTap: showModalQuestionaTipoConta,
                              child: Text(
                                "Criar conta",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Dadosgeralapp().principalColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading == true) ...[
                Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
