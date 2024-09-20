import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/rotas/AppRoutes.dart';
import 'package:friotrim/usuarioGerente/classes/produto.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:friotrim/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:provider/provider.dart';

class CadastrodeProdutosMeuCatalogo extends StatefulWidget {
  const CadastrodeProdutosMeuCatalogo({super.key});

  @override
  State<CadastrodeProdutosMeuCatalogo> createState() =>
      _CadastrodeProdutosMeuCatalogoState();
}

class _CadastrodeProdutosMeuCatalogoState
    extends State<CadastrodeProdutosMeuCatalogo> {
  @override
  void initState() {
    super.initState();
    loadloadIdBarbearia();
    precoProdutoControler.addListener(() {
      final text = precoProdutoControler.text;
      final formattedText = _formatToCurrency(text);
      if (text != formattedText) {
        precoProdutoControler.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedText.length),
          ),
        );
      }
    });
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  String _formatToCurrency(String text) {
    // Remove todos caracteres não numéricos
    final rawText = text.replaceAll(RegExp('[^0-9]'), '');
    final number = double.tryParse(rawText) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter
        .format(number / 100); // Divida por 100 para converter centavos
  }

  final nomeDoProdutoControler = TextEditingController();
  final DescricaoDoProdutoControler = TextEditingController();
  final precoProdutoControler = TextEditingController();
  final estoqueDisponivel = TextEditingController();

  final String imagemUrlFinal = "";
  final int quantidadeVendida = 0;
  bool ativoParaExibir = true;
  final double precoAntigo = 0;
  //funcoes
  XFile? image;

  //GET IMAGEM DO PERFIL - FINAL(CAMERA)
  Future<void> getNewImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      image = pickedFile;
    });
    //await setNewimageOnDB(); funcao pra enviar ao db, aguardar depois e adicionar
  }

  bool loadingAdd = false;

  Future<void> adicionandoNaListaPrincipal() async {
    String valorFormatado =
        precoProdutoControler.text.replaceAll("R\$", "").trim();
    valorFormatado = valorFormatado.replaceAll(",", ".");
    double valorDouble = double.parse(valorFormatado);
    final Produtosavenda _Produtosavenda = Produtosavenda(
      categorias: _selectedItems,
      ativoParaExibir: true,
      descricao: "",
      estoque: int.parse(estoqueDisponivel.text),
      id: Random().nextDouble().toString(),
      nome: nomeDoProdutoControler.text,
      preco: valorDouble,
      precoAntigo: 0,
      quantiavendida: 0,
      urlImage: "",
    );
    if (image == null) {
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Adicione uma Imagem",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              content: Text(
                "Para finalizar, envie uma imagem do Produto que você deseja vender",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                    fontSize: 14,
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
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      try {
        setState(() {
          loadingAdd = true;
        });

        await Provider.of<CriarEEnviarprodutos>(
          context,
          listen: false,
        ).setNewProduct(
          idBarbearia: loadIdBarbearia!,
          urlImage: File(image!.path),
          produtoVenda: _Produtosavenda,
        );
        setState(() {
          loadingAdd = false;
        });
        showDialog(
            context: context,
            builder: (ctx) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context)
                    .pushReplacementNamed(Approutes.VerificacaoDeLogado);
              });
              return AlertDialog(
                title: Text(
                  "Produto Cadastrado com Sucesso!",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                content: Text(
                  "Em alguns instantes seu Produtos Ficará disponível nos catálogos do App",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            });
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Erro ao adicionar"),
                content: Text(
                    "Pedimos desculpas, houve um erro ao criar o produto. Tente novamente em alguns instantes"),
              );
            });
        print("ao enviar o item ao db deu este erro: $e");
      }
    }
  }

  List<String> categorias = [
    'Cabelo',
    'Barba',
    'Corpo',
    'Roupas',
    'Acessórios',
  ];
  List<String> _selectedItems = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        
        onTap: (){  FocusScope.of(context).unfocus();},
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Informações do Produto",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade200,
                                ),
                                child: Icon(
                                  Icons.cancel_rounded,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: image == null
                                  ? Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.24,
                                      child: Image.asset(
                                        "imagesapp/box.png",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.24,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          File(image!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              child: InkWell(
                                onTap: () {
                                  if (!kIsWeb) {
                                    getNewImage();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text(
                                                "Para atualizar a imagem, utilize o App"),
                                            content: Text(
                                                "esta funcão não é permitida pelo Site"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Fechar",
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  transformAlignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Dadosgeralapp().primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Adicionar Imagem",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.library_add,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //outras informações
                        SizedBox(
                          height: 30,
                        ),
                        //NOME DO PRODUTO - INICIO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nome do Produto",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.7,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite um Nome';
                                    }
                                    return null;
                                  },
                                  controller: nomeDoProdutoControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Clique para Digitar",
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
                        SizedBox(
                          height: 15,
                        ),
                        //NOME DO PRODUTO - FIM
                        //PRECO DO PRODUTO - INICIO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preço",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.7,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite um Preço';
                                    }
                                    return null;
                                  },
                                  controller: precoProdutoControler,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                    // Custom formatter to ensure currency format is applied
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Clique para Digitar(R\$)",
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
        
                        //PRECO DO PRODUTO - FIM
                        //inicio das categorias
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Categoria do Produto",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
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
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: isSelected
                                                    ? Dadosgeralapp().primaryColor
                                                    : Colors.grey.shade400,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Text(
                                                item,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black38,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //fim das categorias
                        //ROW DE ESTOQUE
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Quantidade em Estoque:",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.2,
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.height * 0.08,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Quantia?';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: estoqueDisponivel,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Digite",
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
                            ],
                          ),
                        ),
        
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                adicionandoNaListaPrincipal();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Dadosgeralapp().primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Adicionar ao Catálogo",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (loadingAdd == true) ...[
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
