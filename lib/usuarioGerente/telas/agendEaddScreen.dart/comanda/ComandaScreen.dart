import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:friotrim/rotas/verificadorDeLogin.dart';
import 'package:friotrim/usuarioGerente/classes/CorteClass.dart';
import 'package:friotrim/usuarioGerente/classes/comanda.dart';
import 'package:friotrim/usuarioGerente/classes/produto.dart';
import 'package:friotrim/usuarioGerente/classes/servico.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:friotrim/usuarioGerente/funcoes/finalizareCarregarComandas.dart';
import 'package:provider/provider.dart';

class ComandaScreen extends StatefulWidget {
  final double valorTotaldaComanda;
  final double valorServicoFinal;
  final double valorProdutoFinal;
  final List<Produtosavenda> produtosLista;
  final List<Servico> servicoLista;
  final Corteclass corte;
  const ComandaScreen({
    super.key,
    required this.servicoLista,
    required this.valorTotaldaComanda,
    required this.valorProdutoFinal,
    required this.valorServicoFinal,
    required this.corte,
    required this.produtosLista,
  });

  @override
  State<ComandaScreen> createState() => _ComandaScreenState();
}

class _ComandaScreenState extends State<ComandaScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadInicialInfs();
    print("valorServicosTotal: ${widget.valorServicoFinal}");
  }

  void LoadInicialInfs() {
    setPreValorInicial();
    loadloadIdBarbearia();
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  //
  double valorServicosAdicionados = 0;
  double valorProdutosAdicionados = 0;
  double valorFinalTotal = 0;
  void setPreValorInicial() {
    setState(() {
      valorServicosAdicionados = widget.valorServicoFinal;
      valorProdutosAdicionados = widget.valorProdutoFinal;
      valorFinalTotal = widget.valorTotaldaComanda;
    });
  }

  Future<void> FinalizandoComanda() async {
    try {
      Comanda _comanda = Comanda(
        dataFinalizacao: DateTime.now(),
        id: Random().nextDouble().toString(),
        idBarbearia: widget.corte.barbeariaId,
        idBarbeiroQueCriou: widget.corte.profissionalId,
        nomeCliente: widget.corte.clienteNome,
        produtosVendidos: widget.produtosLista,
        servicosFeitos: widget.servicoLista,
        valorTotalComanda: valorFinalTotal,
      );
      await Provider.of<Finalizarecarregarcomandas>(context, listen: false)
          .finalizandoComanda(
            porcentagemGanhaProfissionalCortes: widget.corte.valorQueOProfissionalGanhaPorCortes,
            porcentagemGanhaProfissionalProdutos: widget.corte.valorQueOProfissionalGanhaPorProdutos,
            valorTotalComanda: valorFinalTotal,
            valorTotalServicos: valorServicosAdicionados,
            valorTotalProdutos: valorProdutosAdicionados,
            corte: widget.corte,
        comanda: _comanda,
        idBarbearia: loadIdBarbearia!,
      );
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
                "Comanda finalizada",
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
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Erro ao finalizar",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              content: Text(
                "Tente novamente em alguns segundos, se persistir entre em contato com o suporte. Resolveremos em instantes para você!",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey.shade50,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
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
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      print("publicando a comanda");
    }
  } 
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Conteúdo da tela
            Positioned(
              top: 60,
              left: 15,
              right: 0,
              child: Container(
                width: double.infinity,
                child: Text(
                  "Pré-Finalização",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.width * 0.26,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.95,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.11,
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.network(
                                      widget.corte.urlImagePerfilfoto,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "${widget.corte.clienteNome.replaceAll('CmddCriada', '')}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "+${widget.corte.pontosGanhos} pontos",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
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
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 15),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.8, color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // valor produtos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adicional de Produtos:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "R\$${valorProdutosAdicionados.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // valor servicos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total dos Serviços:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "R\$${valorServicosAdicionados.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // valor total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Custo total:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "R\$${valorFinalTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {
                        setState(() {
                          isLoading = true; // Ativa o loading
                        });

                        await FinalizandoComanda(); // Chama a função de finalização

                        setState(() {
                          isLoading = false; // Desativa o loading
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().primaryColor, // Substitua pela sua cor
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Finalizar agora",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // CircularProgressIndicator quando isLoading for true
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Dadosgeralapp().primaryColor), // Cor do indicador
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
