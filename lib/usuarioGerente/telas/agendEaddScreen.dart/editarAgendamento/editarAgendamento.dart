import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/funcoes/agendarHorario.dart';
import 'package:jimy/rotas/verificadorDeLogin.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/classes/produto.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/comanda/ComandaScreen.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/ProdutoAdicionadoNaAgenda.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/screenDeSelecionarOdia.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/telaOndeMostraOsProdutos.dart';
import 'package:provider/provider.dart';

class EditarAgendamento extends StatefulWidget {
  final Corteclass corte;
  const EditarAgendamento({
    super.key,
    required this.corte,
  });

  @override
  State<EditarAgendamento> createState() => _EditarAgendamentoState();
}

class _EditarAgendamentoState extends State<EditarAgendamento> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = false;
  Future<void> confirmCancelamento() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Agendarhorario>(context, listen: false).apenasDesmarcar(
        corte: widget.corte,
        idBarbearia: widget.corte.barbeariaId,
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
              "Agendamento cancelado",
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
      print("ocorreu este erro:$e");
    }
  }

  double valorProdutosTotal = 0;
  double valorServicosTotal = 0;
  double valorComandaTotal = 0;
  void somandoAComandaTotal() {
    setState(() {
      valorComandaTotal = (valorProdutosTotal + valorServicosTotal);
    });
  }

  void SomandoValorTotal() {
    double totalProdutos = 0; // Variável temporária para armazenar o total

    for (var item in _produtosAdicionados) {
      totalProdutos += item.preco; // Acumula o preço dos produtos
    }

    setState(() {
      valorProdutosTotal = totalProdutos; // Atualiza o valor total
      somandoAComandaTotal(); // Atualiza o total da comanda
    });
  }

  List<Produtosavenda> _produtosAdicionados = [];
  void recebendoALista(List<Produtosavenda> produtos) {
    setState(() {
      _produtosAdicionados = produtos;
      SomandoValorTotal();
    });
  }

  void showScreenComProdutos() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => telaOndeMostraOsProdutos(
          onListaAdicionadosChanged: recebendoALista,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //container da foto - inicio
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.2,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.corte.clienteNome}",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //container da foto - fim
                      SizedBox(
                        height: 15,
                      ),
                      //container do preco - incio
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.2,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Valor",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              "R\$${widget.corte.valorCorte.toStringAsFixed(2).replaceAll('.', ',')}",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //container do preco - incio
                      SizedBox(
                        height: 15,
                      ),
                      //container do profissional
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.2,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profissional",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "${widget.corte.ProfissionalSelecionado}",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //container do profissional
                      SizedBox(
                        height: 15,
                      ),
                      //container data e hora
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.2,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Data e hora",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    "${widget.corte.diaSelecionado} de ${widget.corte.MesSelecionado} - ${widget.corte.horarioSelecionado}",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            EditarODiaDoAgendamento(
                                          corte: widget.corte,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey.shade600,
                                      size: 15,
                                    ),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 0.2,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Produtos:",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (_produtosAdicionados.length == 0)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        "Vendeu algum produto?\nSome junto na comanda!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Icon(
                                      Icons.add,
                                      size: 15,
                                      color: Colors.grey.shade500,
                                    ),
                                  ],
                                ),
                              ),
                            Column(
                                children: _produtosAdicionados.map((item) {
                              return ProdutoAdicionadoNaComanda(
                                produto: item,
                              );
                            }).toList()),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: showScreenComProdutos,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Dadosgeralapp().primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Adicionar produto",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Serviços feitos:",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15)),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "- ${widget.corte.nomeServicoSelecionado}",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${widget.corte.valorCorte.toStringAsFixed(2).replaceAll('.', ',')}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.green.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 15,
              right: 0,
              child: Container(
                width: double.infinity,
                child: Text(
                  "Detalhes da comanda",
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
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                height: MediaQuery.of(context).size.height * 0.08,
                child: Row(
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
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: 0.2,
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Valor total da comanda:",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "R\$${valorComandaTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        //bloco da comanda - inicio
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ComandaScreen(
                                  valorProdutoFinal: valorProdutosTotal,
                                  valorServicoFinal: valorServicosTotal,
                                  valorTotaldaComanda: valorComandaTotal,
                                  corte: widget.corte,
                                ),
                              ));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    color: Dadosgeralapp().tertiaryColor,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Comanda",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: Dadosgeralapp().tertiaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //bloco da comanda - fim
                        //bloco do whatsapp - inicio
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.feedback,
                                    color: Dadosgeralapp().tertiaryColor,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Lembrete",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: Dadosgeralapp().tertiaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //bloco do whatsap - fim
                        //bloco do cancelar - inicio
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        "Cancelar Agendamento?",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Dadosgeralapp().primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      content: Text(
                                        "Ao confirmar você retira este agendamento da agenda geral, e as comissões do barbeiro responsável referente a este serviço",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.black,
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
                                            "Cancelar",
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: confirmCancelamento,
                                          child: Text(
                                            "Confirmar",
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Dadosgeralapp()
                                                    .primaryColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Dadosgeralapp().tertiaryColor,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Cancelar",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: Dadosgeralapp().tertiaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //bloco do cancelar - fim
                      ],
                    ),
                  ],
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
