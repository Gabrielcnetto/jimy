import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/rotas/verificadorDeLogin.dart';
import 'package:Dimy/usuarioGerente/classes/Despesa.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioGerente/funcoes/despesas.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
class DentroDaDespesaPendente extends StatefulWidget {
  final Despesa despesaInfs;
  const DentroDaDespesaPendente({
    super.key,
    required this.despesaInfs,
  });

  @override
  State<DentroDaDespesaPendente> createState() =>
      _DentroDaDespesaPendenteState();
}

class _DentroDaDespesaPendenteState extends State<DentroDaDespesaPendente> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadloadIdBarbearia();
    setHistoricoDatetime();
  }

  List<DateTime> _historicoPagamentos = [];
  void setHistoricoDatetime() {
    setState(() {
      _historicoPagamentos = widget.despesaInfs.historicoPagamentos;
      _historicoPagamentos.sort((a, b) {
        return b.compareTo(a); // Comparação inversa para ordem decrescente
      });
    });
  }

  XFile? image;

  File? resizedImage;

  Future<void> getProfileImageBiblio() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (pickedFile != null) {
      // Carrega a imagem como uma lista de bytes
      final bytes = await pickedFile.readAsBytes();

      // Decodifica a imagem usando a biblioteca `image`
      img.Image? imageTemp = img.decodeImage(bytes);

      // Redimensiona para um tamanho fixo, ex: 300x300
      img.Image resized = img.copyResize(imageTemp!, width: 1080, height: 1080);

      // Salva a imagem redimensionada em um arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final resizedFile = File('${tempDir.path}/resized_image.jpg')
        ..writeAsBytesSync(img.encodeJpg(resized));

      setState(() {
        image = pickedFile;
        resizedImage = resizedFile;
      });
    }
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  bool isLoading = false;
  Future<void> finalizandoDespesa() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<DespesasFunctions>(context, listen: false).FinalizandoDespesa(
        despesaCriada: widget.despesaInfs,
        idBarbearia: loadIdBarbearia!,
        fotoUpload: File(image!.path),
      );
      await Provider.of<DespesasFunctions>(context, listen: false)
          .getDespesasLoad();
      await Provider.of<DespesasFunctions>(context, listen: false)
          .getDespesasPosPagaLoad();
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
            Navigator.of(ctx).pop();
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Pagamento registrado!",
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
    }
  }

  Future<void> removerFuncao() async {
    try {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Confirme a Exclusão",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              content: Text(
                "Atenção, se esta for uma cobraça recorrente. Ela deixará de ser cobrada nos próximos meses!",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Voltar",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed:apagarDeFatoDespesa,
                  child: Text(
                    "Confirmar",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Dadosgeralapp().primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    } catch (e) {
      print("ao remover deu este erro:$e");
    }
  }

  Future<void> apagarDeFatoDespesa() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<DespesasFunctions>(context, listen: false)
          .removendoDespesa(
        despesa: widget.despesaInfs,
        idBarbearia: loadIdBarbearia!,
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
              "Despesa Excluída",
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
      print("Erro ao apagar, deu isto:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // O conteúdo principal da tela
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            widget.despesaInfs.name,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: removerFuncao,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Dadosgeralapp()
                                  .tertiaryColor
                                  .withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Dadosgeralapp().tertiaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: GestureDetector(
                onTap: finalizandoDespesa,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Dadosgeralapp().primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Text(
                    "Confirmar pagamento",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.14,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Valor:",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              "R\$${widget.despesaInfs.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Container para exibir a imagem ou um botão para adicionar uma imagem
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Anexe um comprovante ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (image == null)
                        GestureDetector(
                          onTap: getProfileImageBiblio,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 22,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      if (image != null)
                        GestureDetector(
                          onTap: getProfileImageBiblio,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      if (_historicoPagamentos.isNotEmpty)
                        SizedBox(
                          height: 15,
                        ),
                      if (widget.despesaInfs.recorrente &&
                          _historicoPagamentos.isNotEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Todos os pagamentos",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Datas",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 15,
                                        color: Colors.grey.shade700,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              if (_historicoPagamentos.isNotEmpty)
                                SizedBox(
                                  height: 10,
                                ),
                              if (_historicoPagamentos.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _historicoPagamentos.map((data) {
                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color:
                                                      Colors.grey.shade100))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.check_box,
                                                size: 15,
                                                color: Colors.green.shade700,
                                              ),
                                              Text(
                                                " Pagamento Feito",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            DateFormat("dd/MM/yyyy")
                                                .format(data),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    54, 54, 54, 1),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
              ),
            ),
            // Exibição do CircularProgressIndicator quando isLoading for true
            if (isLoading)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Dadosgeralapp().primaryColor,
                      ),
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
