import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/funcoes/agendarHorario.dart';
import 'package:jimy/rotas/verificadorDeLogin.dart';
import 'package:jimy/usuarioGerente/classes/CorteClass.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/comanda/ComandaScreen.dart';
import 'package:jimy/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/screenDeSelecionarOdia.dart';
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
  bool isLoading = false;
  Future<void> confirmCancelamento() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Agendarhorario>(context, listen: false)
          .apenasDesmarcar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.14,
              left: 0,
              right: 0,
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
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
                        //container do serviço
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
                                "Serviço",
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
                                  "${widget.corte.nomeServicoSelecionado}",
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
                        SizedBox(
                          height: 15,
                        ),
                        //container do servico
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
                        //container data e hora
                      ],
                    ),
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
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
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
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                  child: Row(
                    children: [
                      //bloco da comanda - inicio
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ComandaScreen(corte: widget.corte,),));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  color: Dadosgeralapp().primaryColor,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Comanda",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
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
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 43,
                                height: 43,
                                child: Image.asset(
                                  "imagesapp/whatsappLogo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Lembrete",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
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
                                              color:
                                                  Dadosgeralapp().primaryColor,
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
                                  color: Colors.red,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Cancelar",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
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
