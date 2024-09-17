import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class AdicionarProfissional extends StatefulWidget {
  const AdicionarProfissional({super.key});

  @override
  State<AdicionarProfissional> createState() => _AdicionarProfissionalState();
}

class _AdicionarProfissionalState extends State<AdicionarProfissional> {
  final nomeProfissionalControler = TextEditingController();
  final porcentagemPorCortesControler = TextEditingController();
  final porcentagemPorVendasProdutosControler = TextEditingController();
  final emailControler = TextEditingController();
  final senhaControler = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _forms = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadloadIdBarbearia();
    loadSenhaFunction();
  }

  bool versenha = true;

  XFile? image;
  File? resizedImage;

  Future<void> getProfileImageBiblio() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (pickedFile != null) {
      // Carrega a imagem como uma lista de bytes
      final bytes = await pickedFile.readAsBytes();

      // Decodifica a imagem usando a biblioteca `image`
      img.Image? imageTemp = img.decodeImage(bytes);

      // Redimensiona para um tamanho fixo, ex: 300x300
      img.Image resized = img.copyResize(imageTemp!, width: 1080, height: 1080);

      // Salva a imagem redimensionada em um arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final resizedFile = File('${tempDir.path}/resized_image.jpg')
        ..writeAsBytesSync(img.encodeJpg(resized));

      setState(() {
        image = pickedFile;
        resizedImage = resizedFile;
      });
    }
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  String? loadSenha;
  Future<void> loadSenhaFunction() async {
    String? pass = await Getsdeinformacoes().getsenha();

    setState(() {
      loadSenha = pass;
    });
  }

  bool isLoading = false;
  Future<void> configurarPerfil() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Provider.of<Criarfuncionario>(context, listen: false)
          .CreateProfissional(
              senhaGerente: loadSenha!,
              IddaBarbearia: loadIdBarbearia!,
              email: emailControler.text,
              fotoUpload: resizedImage!,
              porcentagemPorCortes:
                  double.parse(porcentagemPorCortesControler.text),
              porcentagemporProdutos:
                  double.parse(porcentagemPorVendasProdutosControler.text),
              senha: senhaControler.text,
              userName: nomeProfissionalControler.text);
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
            Navigator.of(ctx).pop();
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Perfil criado!",
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
      print("houve um erro: $e");
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
                  child: Form(
                    key: _forms,
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
                                size: 25,
                                color: Dadosgeralapp().primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            "Adicione um Barbeiro",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Informações do profissional",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Foto do barbeiro",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Dadosgeralapp().secundariaColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              image == null
                                  ? Expanded(
                                      child: InkWell(
                                        onTap: getProfileImageBiblio,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Icon(
                                            Icons.add,
                                            size: 25,
                                            color: Dadosgeralapp()
                                                .cinzaParaSubtitulosOuDescs,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(image!.path),
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Enviar imagem",
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: getProfileImageBiblio,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Dadosgeralapp().primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            "carregar",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //FIM DA FOTO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nome do Profissional",
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
                                    Icons.person,
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
                                          return 'Digite um nome';
                                        }
                                        return null;
                                      },
                                      controller: nomeProfissionalControler,
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
                        //fim do nome
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Porcentagem por cortes (%)",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 0.3,
                                  color: Colors.black38,
                                ),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite uma porcentagem';
                                  }
                                  return null;
                                },
                                controller: porcentagemPorCortesControler,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Permite apenas dígitos
                                ],
                                maxLength: 2,
                                textAlign: TextAlign
                                    .center, // Alinha o texto no centro horizontalmente
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Porcentagem na venda de produtos (%)",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 0.3,
                                  color: Colors.black38,
                                ),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite uma porcentagem';
                                  }
                                  return null;
                                },
                                controller:
                                    porcentagemPorVendasProdutosControler,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Permite apenas dígitos
                                ],
                                maxLength: 2,
                                textAlign: TextAlign
                                    .center, // Alinha o texto no centro horizontalmente
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //
                        SizedBox(
                          height: 15,
                        ),

                        Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.black12,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Criar Acesso para o Barbeiro",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cria um e-mail aleatório ou adicione o do seu barbeiro",
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
                                    Icons.mail,
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
                                          return 'Digite um email';
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Crie uma senha",
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
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: InkWell(
                            onTap: () async {
                              if (_forms.currentState!.validate() &&
                                  (image != null ||
                                      image.toString().length < 1)) {
                                configurarPerfil();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Dadosgeralapp().primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Criar Agora",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
