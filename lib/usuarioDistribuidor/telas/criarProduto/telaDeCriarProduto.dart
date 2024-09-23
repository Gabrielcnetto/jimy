import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:Dimy/rotas/verificadorDeLogin.dart';
import 'package:Dimy/usuarioDistribuidor/classes/ProdutoShopping.dart';
import 'package:Dimy/usuarioDistribuidor/funcoes/produtosFunctions.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:image/image.dart' as img;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TelaDeCriarOProdutoDistribuidor extends StatefulWidget {
  const TelaDeCriarOProdutoDistribuidor({super.key});

  @override
  State<TelaDeCriarOProdutoDistribuidor> createState() =>
      _TelaDeCriarOProdutoDistribuidorState();
}

class _TelaDeCriarOProdutoDistribuidorState
    extends State<TelaDeCriarOProdutoDistribuidor> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final nomeProdutoControler = TextEditingController();
  final MarcaProdutoControler = TextEditingController();
  final precoProdutoControler = TextEditingController();
  final precoProdutoParClientes = TextEditingController();
  final estoqueTotalControler = TextEditingController();
  bool venderparaGerentes = false;
  bool venderParaClientes = false;

  List<String> categorias = [
    "Roupas",
    "Perfumes",
    "Cadeiras",
    "Barba",
    "Máquinas",
    "Eletrônicos",
    "Cabelo",
    "Cremes",
    "Outros"
  ];
  List<String> _selectedItems = [];
  bool isUsado = false;
  void modiFyisUsado() {
    setState(() {
      isUsado = !isUsado;
    });
  }

  List<File> fileImages = [];
  final descricaoProdutoControler = TextEditingController();

  Future<void> getProfileImagesBiblio() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage(
      maxWidth: 3840,
      maxHeight: 3840,
    );

    if (pickedFiles != null) {
      // Limitar a seleção de imagens a 4
      if (pickedFiles.length > 5) {
        pickedFiles.removeRange(5, pickedFiles.length); // Remove imagens extras
      }

      for (XFile pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        img.Image? imageTemp = img.decodeImage(bytes);

        if (imageTemp != null) {
          img.Image resized =
              img.copyResize(imageTemp, width: 3840, height: 3840);
          final tempDir = await getTemporaryDirectory();
          final resizedFile =
              File('${tempDir.path}/resized_image_${fileImages.length}.jpg')
                ..writeAsBytesSync(img.encodeJpg(resized));

          // Adiciona imagem redimensionada à lista até no máximo 4
          if (fileImages.length < 5) {
            setState(() {
              fileImages.add(resizedFile);
            });
          }
        }
      }
    }
  }

  Future<void> pubProduct() async {
    setState(() {
      isLoading = true;
    });
    try {
      double parseCurrency(String value) {
        // Remove os caracteres não numéricos, exceto o separador decimal
        String cleanValue =
            value.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
        return double.tryParse(cleanValue) ?? 0.0;
      }

      ProdutoShopping _product = ProdutoShopping(
        urlImageDistribuidora: "",
        nomeDistribuidora: "",
        idDistribuidora: "",
        marca: MarcaProdutoControler.text,
        usado: isUsado,
        palavrasChaves: [],
        exibirParaBarbeiros: venderparaGerentes,
        exibirParaClientes: venderParaClientes,
        categorias: _selectedItems,
        ativoParaExibir: true,
        descricao: descricaoProdutoControler.text,
        estoque: int.parse(estoqueTotalControler.text),
        id: Random().nextDouble().toString(),
        nome: nomeProdutoControler.text,
        precoParaBarbeiros: parseCurrency(precoProdutoControler.text) ?? 0.0,
        quantiavendida: 0,
        urlImagensParaExibir: [],
        precoAntigo: 0,
        precoParaClientes: parseCurrency(precoProdutoParClientes.text) ?? 0.0,
        urlImageFront: "urlImageFront",
      );
      await Provider.of<Produtosfunctions>(context, listen: false)
          .pubNewProdutct(
        produto: _product,
        listaImges: fileImages,
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
              "Produto Publicado!",
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
        });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Ocorreu um erro:$e");
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
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Informações Gerais:",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(54, 54, 54, 1),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  venderparaGerentes =
                                                      !venderparaGerentes;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      venderparaGerentes == true
                                                          ? Colors.grey.shade50
                                                          : Colors.transparent,
                                                      venderparaGerentes == true
                                                          ? Colors.grey.shade100
                                                              .withOpacity(0.6)
                                                          : Colors.transparent,
                                                      venderparaGerentes == true
                                                          ? Colors.grey.shade100
                                                          : Colors.transparent,
                                                    ],
                                                  ),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: venderparaGerentes ==
                                                            true
                                                        ? Colors.black
                                                        : Colors.grey.shade100,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Icon(
                                                          venderparaGerentes ==
                                                                  true
                                                              ? Icons
                                                                  .check_circle
                                                              : Icons
                                                                  .radio_button_unchecked,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Para barbeiros",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Este item será exibido para os profissionais.",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: Colors.black38,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  venderParaClientes =
                                                      !venderParaClientes;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      venderParaClientes == true
                                                          ? Colors.grey.shade50
                                                          : Colors.transparent,
                                                      venderParaClientes == true
                                                          ? Colors.grey.shade100
                                                              .withOpacity(0.6)
                                                          : Colors.transparent,
                                                      venderParaClientes == true
                                                          ? Colors.grey.shade100
                                                          : Colors.transparent,
                                                    ],
                                                  ),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: venderParaClientes ==
                                                            true
                                                        ? Colors.black
                                                        : Colors.grey.shade100,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Icon(
                                                          venderParaClientes ==
                                                                  true
                                                              ? Icons
                                                                  .check_circle
                                                              : Icons
                                                                  .radio_button_unchecked,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Clientes B2C",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Exibido para os Clientes das barbearias.",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: Colors.black38,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //nome
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nome do Produto",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Digite um nome';
                                          }
                                          return null;
                                        },
                                        controller: nomeProdutoControler,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //fim do nome e agora marca
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Marca",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Digite a marca';
                                          }
                                          return null;
                                        },
                                        controller: MarcaProdutoControler,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //fim da marca

                            //comeco preco
                            if (venderparaGerentes == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Preço do Produto para Barbeiros",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.grey.shade200,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          controller: precoProdutoControler,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Digite um preço';
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            CurrencyInputFormatter(),
                                            // Custom formatter to ensure currency format is applied
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (venderParaClientes == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Preço do Produto para Clientes",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.grey.shade200,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          controller: precoProdutoParClientes,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Digite um preço';
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            CurrencyInputFormatter(),
                                            // Custom formatter to ensure currency format is applied
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            //fim preco
                            //estoque

                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quantia em estoque",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        controller: estoqueTotalControler,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Digite uma quantia';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,

                                          // Custom formatter to ensure currency format is applied
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //inicio das categorias
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Categorias do Produto",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: categorias.map(
                                          (item) {
                                            bool isSelected =
                                                _selectedItems.contains(item);
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (isSelected) {
                                                    _selectedItems.remove(
                                                        item); // Remove se já estiver selecionado
                                                  } else {
                                                    _selectedItems.add(
                                                        item); // Adiciona se não estiver selecionado
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: isSelected
                                                            ? Dadosgeralapp()
                                                                .primaryColor
                                                            : Colors
                                                                .grey.shade400,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 15),
                                                      child: Text(
                                                        item,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: isSelected
                                                                ? Colors.white
                                                                : Colors
                                                                    .black38,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Parte 2
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Qual a condição deste produto?",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: modiFyisUsado,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(isUsado == true
                                                  ? Icons.check_circle
                                                  : Icons
                                                      .radio_button_unchecked),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Usado",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: modiFyisUsado,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(isUsado == false
                                                  ? Icons.check_circle
                                                  : Icons
                                                      .radio_button_unchecked),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Novo",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Imagens e Descrição do Produto",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Imagens do Produto",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color:
                                                Dadosgeralapp().tertiaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "  Máximo 5 Imagens*",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color:
                                                Dadosgeralapp().tertiaryColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListView.builder(
                                      scrollDirection: Axis
                                          .horizontal, // Exibição horizontal
                                      itemCount: 5, // Mostra até 4 itens
                                      itemBuilder: (ctx, index) {
                                        if (index < fileImages.length) {
                                          // Exibe a imagem redimensionada
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                fileImages[index],
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                            ),
                                          );
                                        } else {
                                          // Exibe um container cinza se não houver imagem
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: GestureDetector(
                                              onTap: getProfileImagesBiblio,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Adicione uma Descrição",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color:
                                                Dadosgeralapp().tertiaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 0.7,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 25,
                                            horizontal: 10,
                                          ),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Digite uma descrição';
                                              }
                                              return null;
                                            },
                                            maxLines:
                                                15, // Permite que o campo expanda verticalmente
                                            minLines: 1,
                                            controller:
                                                descricaoProdutoControler,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              label: Text(
                                                "Descreva o Produto para os clientes",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black38,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState!.validate() &&
                                          categorias.length > 0 &&
                                          fileImages.length > 0 &&
                                          (venderParaClientes ||
                                              venderparaGerentes != false)) {
                                        pubProduct();
                                      } else {
                                        return;
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Dadosgeralapp().primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Colocar na vitrine",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
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
                  child: CircularProgressIndicator(
                    color: Dadosgeralapp().primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final number = double.tryParse(rawText) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    final formattedText = formatter.format(number / 100);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formattedText.length),
      ),
    );
  }
}
