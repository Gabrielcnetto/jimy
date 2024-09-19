import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/minhaPagina/editarWallpapers/bannerItem.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Editarwallpapers extends StatefulWidget {
  const Editarwallpapers({super.key});

  @override
  State<Editarwallpapers> createState() => _EditarwallpapersState();
}

class _EditarwallpapersState extends State<Editarwallpapers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).loadBanners();
  }

  bool isLoading = false;
  XFile? image;
  File? resizedImage;

  Future<void> getProfileImageBiblio() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920,
      maxWidth: 1080,
    );

    if (pickedFile != null) {
      // Carrega a imagem como uma lista de bytes
      final bytes = await pickedFile.readAsBytes();

      // Decodifica a imagem usando a biblioteca `image`
      img.Image? imageTemp = img.decodeImage(bytes);

      // Redimensiona para um tamanho fixo, ex: 300x300
      img.Image resized = img.copyResize(imageTemp!, width: 1920, height: 1080);

      // Salva a imagem redimensionada em um arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final resizedFile = File('${tempDir.path}/resized_image.jpg')
        ..writeAsBytesSync(img.encodeJpg(resized));

      setState(() async {
        image = pickedFile;
        resizedImage = resizedFile;
        sendToDb();
      });
    }
  }

  Future<void> sendToDb() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .sendNewBanner(
        file: resizedImage!,
        idForImage: Random().nextDouble().toString(),
      );

      await Provider.of<Getsdeinformacoes>(context, listen: false)
          .loadBanners();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Houve um erro ao enviar a imagem:$e");
    }
  }

  void getBoolSoon(bool bool){
    setState(() {
      isLoading = bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
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
                          "Seus Banners",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: StreamBuilder(
                        stream: Provider.of<Getsdeinformacoes>(context,
                                listen: false)
                            .bannersStream,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Dadosgeralapp().primaryColor,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Houve um erro...",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                alignment: Alignment.center,
                                child: Text(
                                  "Você não tem nenhum banner adicionado",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            List<String> banners =
                                snapshot.data as List<String>;
                            return Column(
                              children: banners.map((banner) {
                                return BannerItemView(
                                  onButtonPressed: getBoolSoon,
                                  urlImage: banner,
                                );
                              }).toList(),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: getProfileImageBiblio,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Dadosgeralapp().primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Text(
                            "Enviar banner",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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
    );
  }
}
