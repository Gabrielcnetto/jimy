import 'package:flutter/material.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/funcoes/CriarContaeLogar.dart';
import 'package:fiotrim/rotas/AppRoutes.dart';
import 'package:fiotrim/usuarioDistribuidor/classes/ProdutoShopping.dart';
import 'package:fiotrim/usuarioDistribuidor/funcoes/produtosFunctions.dart';
import 'package:fiotrim/usuarioDistribuidor/telas/components/itemViewMyProduct.dart';
import 'package:fiotrim/usuarioDistribuidor/telas/produtosAdicionados/componentes/listaEBotaoVenderAgora.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TelaProdutosAdicionados extends StatefulWidget {
  const TelaProdutosAdicionados({super.key});

  @override
  State<TelaProdutosAdicionados> createState() =>
      _TelaProdutosAdicionadosState();
}

class _TelaProdutosAdicionadosState extends State<TelaProdutosAdicionados> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaduserImageURL();
    Provider.of<Produtosfunctions>(context, listen: false)
        .LoadProductsBarbearia();
  }

  String? userImageURL;
  Future<void> loaduserImageURL() async {
    String? urldb = await Getsdeinformacoes().getUserURLImage();

    setState(() {
      userImageURL = urldb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: StreamBuilder(
                      stream: Provider.of<Produtosfunctions>(context, listen: false)
                          .ProdutosAvendaStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Dadosgeralapp().primaryColor,
                            ),
                          );
                        }
                        if (snapshot.hasError || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListEBotaoVenderAgora(),
                                Text(
                                  "Nenhum produto",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          List<ProdutoShopping> listaCompleta =
                              snapshot.data as List<ProdutoShopping>;
                          return Container(
                               width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 1,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ListEBotaoVenderAgora(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 1.5,
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              2, // Define o número de colunas
                                          crossAxisSpacing:
                                              8.0, // Espaçamento horizontal entre as colunas
                                          mainAxisSpacing:
                                              8.0, // Espaçamento vertical entre as linhas
                                          childAspectRatio: 0.5, // Ajuste da proporção de largura/altura dos itens
                                        ),
                                        itemCount: listaCompleta.length,
                                        itemBuilder: (context, index) {
                                          return MYProducList(
                                            produto: listaCompleta[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                ),
              ],
            ),
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.14,
          ),
          Positioned(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                color: Dadosgeralapp().primaryColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seu Catálogo",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<CriarcontaelogarProvider>(context,
                                  listen: false)
                              .deslogar();
                          Navigator.of(context).pushReplacementNamed(
                              Approutes.VerificacaoDeLogado);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              40,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              "${userImageURL ?? Dadosgeralapp().defaultAvatarImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            top: 0,
            right: 0,
            left: 0,
          ),
        ],
      ),
    );
  }
}
