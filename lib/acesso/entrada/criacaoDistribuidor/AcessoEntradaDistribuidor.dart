import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/funcoes/CriarContaeLogar.dart';
import 'package:friotrim/rotas/verificadorDeLogin.dart';
import 'package:provider/provider.dart';

class AcessoEntradaDistribuidorScreen extends StatefulWidget {
  const AcessoEntradaDistribuidorScreen({super.key});

  @override
  State<AcessoEntradaDistribuidorScreen> createState() =>
      _AcessoEntradaDistribuidorScreenState();
}

class _AcessoEntradaDistribuidorScreenState
    extends State<AcessoEntradaDistribuidorScreen> {
  final responsavelNameControler = TextEditingController();
  final cnpjControler = TextEditingController();
  final contatoTelefoneControler = TextEditingController();
  final estadoControler = TextEditingController();
  final cepControler = TextEditingController();
  final BairroControler = TextEditingController();
  final numeroControler = TextEditingController();
  final nomeruaControler = TextEditingController();
  final emailControler = TextEditingController();
  final senhaControler = TextEditingController();
  final nomeDaLojaControler = TextEditingController();
  bool versenha = true;
  //keys
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  bool isLoading = false;
  Future<void> criarPerfil() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Chama o método para criar a conta
      await Provider.of<CriarcontaelogarProvider>(listen: false, context)
          .criarContaClienteDistribuidor(
        bairro: BairroControler.text,
        cep: cepControler.text,
        cnpj: cnpjControler.text,
        email: emailControler.text,
        estado: estadoControler.text,
        idDistribuidora: Random().nextDouble().toString(),
        nomeDistribuidora: nomeDaLojaControler.text,
        numeroContato: numeroControler.text,
        password: senhaControler.text,
        rua: nomeruaControler.text,
        userName: responsavelNameControler.text,
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _keyForm,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Venda na ${Dadosgeralapp().nomeSistema}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Text(
                                    "Anúncie seus produtos no shopping para os clientes em todo o Brasil que utilizam a ${Dadosgeralapp().nomeSistema} para agendar, e B2B para os profissionais.",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dados da sua Loja",
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
                                  "Nome da Loja",
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
                                    controller: nomeDaLojaControler,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Digite o nome da Loja';
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
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nome do Responsável",
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
                                    controller: responsavelNameControler,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Digite seu nome';
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
                            //FIM NOME
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CNPJ",
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
                                    maxLength: 18,
                                    controller: cnpjControler,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !value.contains(".") ||
                                          !value.contains("-") ||
                                          !value.contains("/")) {
                                        return 'CNPJ completo, com mascara inclusa';
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
                            //fim cnpj
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Contato Telefone",
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
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Filtra para aceitar apenas dígitos
                                    ],
                                    controller: contatoTelefoneControler,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Adicione um contato';
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Endereço",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estado",
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
                                    maxLength: 2,
                                    controller: estadoControler,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Adicione seu estado';
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
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Filtra para aceitar apenas dígitos
                                    ],
                                    maxLength: 8,
                                    controller: cepControler,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Adicione seu CEP';
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
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Bairro e Número",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 0.8,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly, // Filtra para aceitar apenas dígitos
                                        ],
                                        controller: numeroControler,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Adicione seu Número';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Número",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 0.8,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: TextFormField(
                                        controller: BairroControler,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Adicione seu Bairro';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Seu Bairro",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nome da rua",
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
                                    controller: nomeruaControler,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Adicione sua Rua';
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Acesso à conta",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Seu e-mail",
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
                                        return 'Adicione seu e-mail';
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
                            SizedBox(
                              height: 5,
                            ),
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
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 30),
                              child: InkWell(
                                onTap: () {
                                  if (_keyForm.currentState!.validate()) {
                                    criarPerfil();
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
                            ),
                          ],
                        ),
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
