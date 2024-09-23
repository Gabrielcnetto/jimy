import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/funcoes/CriarContaeLogar.dart';
import 'package:Dimy/rotas/verificadorDeLogin.dart';
import 'package:provider/provider.dart';

class AcessoEntradaDonoBarbearia extends StatefulWidget {
  const AcessoEntradaDonoBarbearia({super.key});

  @override
  State<AcessoEntradaDonoBarbearia> createState() =>
      _AcessoEntradaDonoBarbeariaState();
}

class _AcessoEntradaDonoBarbeariaState
    extends State<AcessoEntradaDonoBarbearia> {
  final emailControler = TextEditingController();
  final senhaControler = TextEditingController();
  final gerenteNameControler = TextEditingController();
  final NomeBarbeariaControler = TextEditingController();
  final CidadeControler = TextEditingController();
  final Cepcontroler = TextEditingController();
  //keys
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _primeiroForms = GlobalKey<FormState>();
  final GlobalKey<FormState> _segundoForms = GlobalKey<FormState>();
  bool versenha = true;
  bool proximosDados = false;
  bool isLoading = false;
  Future<void> criarPerfis() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Chama o método para criar a conta
      await Provider.of<CriarcontaelogarProvider>(listen: false, context)
          .criarContaClienteGerenteBarbearia(
        cep: Cepcontroler.text,
        cidade: CidadeControler.text,
        email: emailControler.text,
        password: senhaControler.text,
        idBarbearia: Random().nextDouble().toString(),
        userName: gerenteNameControler.text,
        nomeBarbearia: NomeBarbeariaControler.text,
      );

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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VerificacaoDeLogado()),
            );
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Perfil Criado",
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
        isLoading =
            false; // Certifica-se de parar o carregamento em caso de erro
      });

      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Erro ao criar a conta"),
            content:
                Text("Verifique os dados, se persistir aguarde alguns segundos"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Registrar Barbearia",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          "Estes dados serão exibidos aos seus clientes dentro do ${Dadosgeralapp().nomeSistema}. Adicione os dados reais.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (proximosDados == false)
                        Form(
                          key: _primeiroForms,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dados de Acesso",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //inicio dos dados
                              Column(
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
                                        if (value == null ||
                                            value.isEmpty ||
                                            !value.contains("@")) {
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
                              //email - fim
                              SizedBox(
                                height: 5,
                              ),
                              //nome do gestor
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nome do Gerente",
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
                                      controller: gerenteNameControler,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite um nome';
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
                              //email - fim
                              SizedBox(
                                height: 5,
                              ),
                              //senha
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Crie uma Senha",
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.length < 3) {
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
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                versenha = !versenha;
                                              });
                                            },
                                            child: Icon(
                                              versenha == true
                                                  ? Icons.remove_red_eye_sharp
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //senha fim
                              SizedBox(
                                height: 10,
                              ),

                              InkWell(
                                onTap: () {
                                  if (_primeiroForms.currentState!.validate()) {
                                    setState(() {
                                      proximosDados = true;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Dadosgeralapp().primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Próximo",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 16,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      if (proximosDados == true)
                        Form(
                          key: _segundoForms,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Informações da sua Barbearia",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Dadosgeralapp()
                                        .cinzaParaSubtitulosOuDescs,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //inicio dos dados
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nome da Barbearia",
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
                                      controller: NomeBarbeariaControler,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite um nome';
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
                              //nome - fim

                              SizedBox(
                                height: 5,
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cidade",
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
                                      controller: CidadeControler,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite a cidade';
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
                              //cidade - fim
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CEP",
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
                                      maxLength: 8,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter
                                            .digitsOnly, // Filtra para aceitar apenas dígitos
                                      ],
                                      controller: Cepcontroler,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite o CEP';
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
                              //nome - fim
                              SizedBox(
                                height: 15,
                              ),

                              InkWell(
                                onTap: () {
                                  if (_segundoForms.currentState!.validate()) {
                                    criarPerfis();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Dadosgeralapp().primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Criar Agora",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 16,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ],
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
