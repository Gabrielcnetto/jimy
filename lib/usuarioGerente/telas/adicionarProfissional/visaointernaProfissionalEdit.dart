import 'dart:async';
import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/classes/barbeiros.dart';
import 'package:Dimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class VisaoInternaProfissional extends StatefulWidget {
  final Barbeiros barber;
  const VisaoInternaProfissional({
    super.key,
    required this.barber,
  });

  @override
  State<VisaoInternaProfissional> createState() =>
      _VisaoInternaProfissionalState();
}

class _VisaoInternaProfissionalState extends State<VisaoInternaProfissional> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadloadIdBarbearia();
    nomeDoProfissionalControler.text = widget.barber.name;
    porcentagemPorCortesControler.text =
        widget.barber.porcentagemCortes.toString().replaceAll('.0', '');
    porcentagemporProdutos.text =
        widget.barber.porcentagemProdutos.toString().replaceAll('.0', '');
  }

  final nomeDoProfissionalControler = TextEditingController();
  final porcentagemPorCortesControler = TextEditingController();
  final porcentagemporProdutos = TextEditingController();
  double porcentagemporcorte = 0;

  //
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

  Future<void> atualizarPerfil() async {
    try {
      setState(() {
        isLoading = true;
      });
      //funcao aqui
      if (image != null) {
        await Provider.of<Criarfuncionario>(context, listen: false)
            .alterarFotoDePerfilBarbeiro(
          idBarbearia: loadIdBarbearia!,
          fotoNova: resizedImage!,
          idBarbeiro: widget.barber.id,
        );
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .getListaProfissionais();
      }
      if (widget.barber.name != nomeDoProfissionalControler.text) {
        await Provider.of<Criarfuncionario>(context, listen: false)
            .alterarNomeProfissional(
                idBarbearia: loadIdBarbearia!,
                newName: nomeDoProfissionalControler.text,
                idBarbeiro: widget.barber.id);
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .getListaProfissionais();
      }
      if (widget.barber.porcentagemCortes !=
          porcentagemPorCortesControler.text) {
        await Provider.of<Criarfuncionario>(context, listen: false)
            .updatePorcentagemCortes(
                idBarbearia: loadIdBarbearia!,
                porcentagemCortes:
                    double.parse(porcentagemPorCortesControler.text),
                idBarbeiro: widget.barber.id);
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .getListaProfissionais();
      }
      if (widget.barber.porcentagemProdutos != porcentagemporProdutos.text) {
        await Provider.of<Criarfuncionario>(context, listen: false)
            .updatePorcentagemprodutos(
                idBarbearia: loadIdBarbearia!,
                porcentagemProdutos: double.parse(porcentagemporProdutos.text),
                idBarbeiro: widget.barber.id);
        await Provider.of<Getsdeinformacoes>(context, listen: false)
            .getListaProfissionais();
      }

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
            Navigator.of(ctx).pop();
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Perfil atualizado!",
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
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Dados incorretos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              content: Text(
                "Verifique os dados inseridos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
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
                        fontWeight: FontWeight.w600,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      print("houve um erro: $e");
    }
  }

  Future<void> deleteBarbeiro() async {
    try {
      setState(() {
        isLoading = true;
      });

      //deletar
      await Provider.of<Criarfuncionario>(context, listen: false)
          .deletarBarbeiro(
              idBarbearia: loadIdBarbearia!, idBarbeiro: widget.barber.id);
      //deletar
      await Provider.of<Getsdeinformacoes>(context, listen: false)
          .getListaProfissionais();
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
            Navigator.of(ctx).pop();
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Perfil Excluído!",
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
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Erro ao deletar",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              content: Text(
                "Aguarde, ou entre em contato com o suporte.",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
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
                        fontWeight: FontWeight.w600,
                        color: Dadosgeralapp().primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      print("houve um erro: $e");
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
                              size: 20,
                              color: Dadosgeralapp().primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.barber.name}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16,
                              ),
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
                              "Área de edicão",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Dadosgeralapp()
                                      .cinzaParaSubtitulosOuDescs,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: deleteBarbeiro,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Imagem do profissional",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Dadosgeralapp().secundariaColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          image != null
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    child: Image.file(
                                      File(image!.path),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      widget.barber.urlImageFoto,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: getProfileImageBiblio,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Dadosgeralapp().primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              alignment: Alignment.center,
                              child: Text(
                                "Atualizar imagem",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      //forms
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome do Profissional",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: nomeDoProfissionalControler,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Porcentagem por cortes (%)",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.3,
                                color: Colors.black38,
                              ),
                            ),
                            child: TextFormField(
                              controller: porcentagemPorCortesControler,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Permite apenas dígitos
                              ],
                              maxLength: 2,
                              textAlign: TextAlign
                                  .center, // Alinha o texto no centro horizontalmente
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Porcentagem por produtos (%)",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.3,
                                color: Colors.black38,
                              ),
                            ),
                            child: TextFormField(
                              controller: porcentagemporProdutos,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Permite apenas dígitos
                              ],
                              maxLength: 2,
                              textAlign: TextAlign
                                  .center, // Alinha o texto no centro horizontalmente
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Informações de Acesso",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "E-mail de acesso",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.mail,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  widget.barber.emailAcesso,
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Senha de Acesso",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  widget.barber.senhaAcesso,
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: InkWell(
                          onTap: atualizarPerfil,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Dadosgeralapp().primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Atualizar dados",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
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
      ),
    );
  }
}
