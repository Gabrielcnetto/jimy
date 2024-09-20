import 'dart:io';
import 'package:friotrim/DadosGeralApp.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Parte3 extends StatefulWidget {
  final Function(List<File>) files;
  const Parte3({
    super.key,
    required this.files,
  });

  @override
  State<Parte3> createState() => _Parte3State();
}

class _Parte3State extends State<Parte3> {
  List<File> fileImages = [];
  final descricaoProdutoControler = TextEditingController();

  Future<void> getProfileImagesBiblio() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (pickedFiles != null) {
      // Limitar a seleção de imagens a 4
      if (pickedFiles.length > 5) {
        pickedFiles.removeRange(5, pickedFiles.length); // Remove imagens extras
      }

      for (XFile pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        img.Image? imageTemp = img.decodeImage(bytes);

        if (imageTemp != null) {
          img.Image resized =
              img.copyResize(imageTemp, width: 1080, height: 1080);
          final tempDir = await getTemporaryDirectory();
          final resizedFile =
              File('${tempDir.path}/resized_image_${fileImages.length}.jpg')
                ..writeAsBytesSync(img.encodeJpg(resized));

          // Adiciona imagem redimensionada à lista até no máximo 4
          if (fileImages.length < 5) {
            setState(() {
              fileImages.add(resizedFile);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Imagens e Descrição do Produto",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Row(
                children: [
                  Text(
                    "Imagens do Produto",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Dadosgeralapp().tertiaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "  Máximo 5 Imagens*",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Dadosgeralapp().tertiaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Exibição horizontal
                  itemCount: 5, // Mostra até 4 itens
                  itemBuilder: (ctx, index) {
                    if (index < fileImages.length) {
                      // Exibe a imagem redimensionada
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            fileImages[index],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                      );
                    } else {
                      // Exibe um container cinza se não houver imagem
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: getProfileImagesBiblio,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adicione uma Descrição",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Dadosgeralapp().tertiaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 0.7,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 10,
                      ),
                      child: TextFormField(
                        maxLines:
                            15, // Permite que o campo expanda verticalmente
                        minLines: 1,
                        controller: descricaoProdutoControler,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            "Descreva o Produto para os clientes",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black38,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Dadosgeralapp().primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Colocar na vitrine",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
