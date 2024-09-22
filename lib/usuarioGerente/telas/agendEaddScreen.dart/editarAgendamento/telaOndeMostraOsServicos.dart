import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/produto.dart';
import 'package:fiotrim/usuarioGerente/classes/servico.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:provider/provider.dart';

class TelaOndeMostraOsServicos extends StatefulWidget {
  final String idDoServicoAtual;
  final Function(List<Servico>) onListaAdicionadosChanged;
  const TelaOndeMostraOsServicos({
    super.key,
    required this.onListaAdicionadosChanged,
    required this.idDoServicoAtual,
  });

  @override
  State<TelaOndeMostraOsServicos> createState() =>
      _TelaOndeMostraOsServicosState();
}

class _TelaOndeMostraOsServicosState extends State<TelaOndeMostraOsServicos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTotal();
  }

  void LoadTotal() async {
    await Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaServicos();
  }

  List<Servico> listaDeAdicionados = [];
  Servico? itemSelecionado;

  void _toggleItem(Servico item) {
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
                    stream:
                        Provider.of<Getsdeinformacoes>(context, listen: false)
                            .getServiceList,
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
                            "Sem Serviços cadastrados",
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
                        final List<Servico>? servicoLista = snapshot.data;
                          final List<Servico> servicosFiltrados = servicoLista!.where((servico) => servico.id != widget.idDoServicoAtual).toList();

                        return SingleChildScrollView(
                          child: Column(
                            children: servicosFiltrados!.map(
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
                                                    0.13,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ClipRRect(
                                                  child: Image.asset(
                                                    "imagesapp/iconeservico.png",
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
                                                      "${item.name}",
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
                                                      "R\$${item.price.toStringAsFixed(2).replaceAll('.', ',')}",
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
                      "Adicionar Serviços",
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
                        "Escolha os Serviços",
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
