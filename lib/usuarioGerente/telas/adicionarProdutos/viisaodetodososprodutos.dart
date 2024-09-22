import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/produto.dart';
import 'package:fiotrim/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:fiotrim/usuarioGerente/telas/adicionarProdutos/produtoItem.dart';
import 'package:fiotrim/usuarioGerente/telas/adicionarProdutos/telaDeCriarUmProduto.dart';
import 'package:fiotrim/usuarioGerente/telas/adicionarProdutos/visaoInternaProduto.dart';
import 'package:provider/provider.dart';

class VisaoDeTodosOsProdutos extends StatefulWidget {
  const VisaoDeTodosOsProdutos({super.key});

  @override
  State<VisaoDeTodosOsProdutos> createState() => _VisaoDeTodosOsProdutosState();
}

class _VisaoDeTodosOsProdutosState extends State<VisaoDeTodosOsProdutos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CriarEEnviarprodutos>(context, listen: false)
        .LoadProductsBarbearia();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CadastrodeProdutosMeuCatalogo(),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Adicionar produto",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 2,
                color: Colors.grey.shade200,
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                stream:
                    Provider.of<CriarEEnviarprodutos>(context, listen: false)
                        .ProdutosAvendaStream,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Dadosgeralapp().primaryColor,
                    ));
                  }
                  if (snapshot.data!.isEmpty) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return CadastrodeProdutosMeuCatalogo();
                        }));
                      },
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text(
                              "Adicione seu Primeiro Produto",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final List<Produtosavenda>? produtosLista = snapshot.data;
                    return Column(
                      children: produtosLista!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => VisaoInternaDoProdutoCriado(
                                  produto: item,
                                ),
                              ));
                            },
                            child: ItemParaVenda(
                              produto: item,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
