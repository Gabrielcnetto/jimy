import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/funcoes/CriarContaeLogar.dart';
import 'package:provider/provider.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final emailControler = TextEditingController();
  bool isLoading = false;

  Future<void> enviarTrocaDeSenha() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Chama o método para criar a conta
      await Provider.of<CriarcontaelogarProvider>(context, listen: false)
          .resetPassword(emailController: emailControler.text);

      setState(() {
        isLoading = false;
      });

      // Mostra o AlertDialog
      showDialog(
        context: context,
        barrierDismissible:
            false, // Evita que o diálogo seja fechado ao tocar fora dele
        builder: (ctx) {
          // Inicia um Timer para fechar o diálogo e redirecionar após 3 segundos
          Timer(Duration(seconds: 3), () {
            Navigator.of(ctx).pop(); // Fecha o diálogo
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Verifique o seu E-mail",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ),
            content: Text(
              "Passo a passo para mudança de senha enviado.",
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
        isLoading =
            false; // Certifica-se de parar o carregamento em caso de erro
      });

      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Erro ao enviar e-mail"),
            content: Text(
                "Verifique os dados, se persistir aguarde alguns segundos"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Fechar"),
              ),
            ],
          );
        },
      );
      print("Ao criar conta deu isto: $e");
    }
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Dadosgeralapp().primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Recuperar Senha",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Text(
                          "Enviaremos um e-mail com as instruções para alteração da senha ao e-mail adicionado abaixo. Caso o mesmo tenha uma conta registrada no ${Dadosgeralapp().nomeSistema}.",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                            ),
                          ),
                        ),
                      ),
                      //email
                      SizedBox(
                        height: 25,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Qual o seu e-mail?",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.8,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextFormField(
                                controller: emailControler,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite um e-mail';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //email - fim
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            enviarTrocaDeSenha();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Dadosgeralapp().primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Alterar a Senha",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
