import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/produto.dart';
import 'package:Dimy/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:provider/provider.dart';

class telaOndeMostraOsProdutos extends StatefulWidget {
  final Function(List<Produtosavenda>) onListaAdicionadosChanged;
  const telaOndeMostraOsProdutos(
      {super.key, required this.onListaAdicionadosChanged});

  @override
  State<telaOndeMostraOsProdutos> createState() =>
      _telaOndeMostraOsProdutosState();
}

class _telaOndeMostraOsProdutosState extends State<telaOndeMostraOsProdutos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTotal();
  }

  void LoadTotal() async {
    await Provider.of<CriarEEnviarprodutos>(context, listen: false)
        .LoadProductsBarbearia();
  }

  List<Produtosavenda> listaDeAdicionados = [];
  Produtosavenda? itemSelecionado;

  void _toggleItem(Produtosavenda item) {
    setState(() {
      if (listaDeAdicionados.contains(item)) {
        listaDeAdicionados.remove(item);
      } else {
        listaDeAdicionados.add(item);
      }
    });
  }

  void _finalizarSelecao() {
    // Chama o callback para passar a lista de adicionados de volta para a tela anterior
    widget.onListaAdicionadosChanged(listaDeAdicionados);
    Navigator.of(context).pop(); // Fecha a tela atual
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 40,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  // Definindo a largura
                  height: MediaQuery.of(context).size.height * 0.8,
                  // Adicione uma cor de fundo temporária
                  child: StreamBuilder(
                    stream: Provider.of<CriarEEnviarprodutos>(context,
                            listen: false)
                        .ProdutosAvendaStream,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Dadosgeralapp().primaryColor,
                          ),
                        );
                      }
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Sem Produtos cadastrados",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        final List<Produtosavenda>? produtosLista =
                            snapshot.data;
                        return SingleChildScrollView(
                          child: Column(
                            children: produtosLista!.map(
                              (item) {
                                bool isSelected =
                                    listaDeAdicionados.contains(item);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTap: () => _toggleItem(item),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Dadosgeralapp().primaryColor
                                            : Colors.grey.shade100
                                                .withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    item.urlImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.nome,
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "R\$${item.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Colors.grey
                                                                  .shade400,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              size: 35,
                                              color: Colors.white,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.17,
                child: InkWell(
                  onTap: _finalizarSelecao,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Dadosgeralapp().tertiaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Salvar itens",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      InkWell(
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
                        "Escolha os produtos",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  SizedBox(height: 15), // Ajuste o espaço conforme necessário
            ),
          ],
        ),
      ),
    );
  }
}
