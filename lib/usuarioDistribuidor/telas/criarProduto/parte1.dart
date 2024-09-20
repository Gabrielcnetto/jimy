import 'package:flutter/material.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:google_fonts/google_fonts.dart';

class Parte1Informacoes extends StatefulWidget {
  final Function(bool) parte1ok;
  final Function(String) nomeProduto;
  final Function(String) marcaProduto;
  final Function(List<String>) categorias;
  const Parte1Informacoes({
    super.key,
    required this.parte1ok,
    required this.categorias,
    required this.marcaProduto,
    required this.nomeProduto,
  });

  @override
  State<Parte1Informacoes> createState() => _Parte1InformacoesState();
}

class _Parte1InformacoesState extends State<Parte1Informacoes> {
  final nomeProdutoControler = TextEditingController();
  final MarcaProdutoControler = TextEditingController();
  bool venderparaGerentes = false;
  bool venderParaClientes = false;

  List<String> categorias = [
    "Roupas",
    "Perfumes",
    "Cadeiras",
    "Barba",
    "Máquinas",
    "Eletrônicos"
        "Cabelo",
    "Cremes",
    "Outros"
  ];
  List<String> _selectedItems = [];
  void adjusteInfs() {
    setState(() {
      widget.parte1ok(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
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
                                venderparaGerentes = !venderparaGerentes;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    venderparaGerentes == true
                                        ? Colors.grey.shade50
                                        : Colors.transparent,
                                    venderparaGerentes == true
                                        ? Colors.grey.shade100.withOpacity(0.6)
                                        : Colors.transparent,
                                    venderparaGerentes == true
                                        ? Colors.grey.shade100
                                        : Colors.transparent,
                                  ],
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: venderparaGerentes == true
                                      ? Colors.black
                                      : Colors.grey.shade100,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        venderparaGerentes == true
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Para barbeiros",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Este item será exibido para os profissionais.",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
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
                                venderParaClientes = !venderParaClientes;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    venderParaClientes == true
                                        ? Colors.grey.shade50
                                        : Colors.transparent,
                                    venderParaClientes == true
                                        ? Colors.grey.shade100.withOpacity(0.6)
                                        : Colors.transparent,
                                    venderParaClientes == true
                                        ? Colors.grey.shade100
                                        : Colors.transparent,
                                  ],
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: venderParaClientes == true
                                      ? Colors.black
                                      : Colors.grey.shade100,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        venderParaClientes == true
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Clientes B2C",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Exibido para os Clientes das barbearias.",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
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
                      controller: nomeProdutoControler,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                     
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      controller: MarcaProdutoControler,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                     
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ],
              ),
            ),
          ),
          //fim da marca
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: categorias.map(
                        (item) {
                          bool isSelected = _selectedItems.contains(item);
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
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSelected
                                          ? Dadosgeralapp().primaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
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
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () {
                          if (nomeProdutoControler.text != "" &&
                              MarcaProdutoControler.text != "" &&
                              _selectedItems.isNotEmpty && (venderparaGerentes ||venderParaClientes !=false)) {
                                print("ta true");
                            setState(() {
                              adjusteInfs();
                            });
                          } else {
                            print("ta false");
                            return;
                          }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Avançar",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: Colors.white,
                            ),
                          ],
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
    );
  }
}
