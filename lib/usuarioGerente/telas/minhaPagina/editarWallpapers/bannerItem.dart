import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class BannerItemView extends StatefulWidget {
  final Function(bool) onButtonPressed;
  final String urlImage;

  const BannerItemView({
    super.key,
    required this.urlImage,
    required this.onButtonPressed,
  });

  @override
  State<BannerItemView> createState() => _BannerItemViewState();
}

class _BannerItemViewState extends State<BannerItemView> {
  void confirmExc() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Você deseja remover o Banner",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          content: Text(
            "Você realmente deseja remover este banner? Ele será desativado do seu perfil na ${Dadosgeralapp().nomeSistema}",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                removerBanner();
              },
              child: Text(
                "Remover",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Dadosgeralapp().primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> removerBanner() async {
    try {
      setState(() {
        widget.onButtonPressed(true);
      });
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .removeBanner(
        url: widget.urlImage,
      );

      await Provider.of<Getsdeinformacoes>(context, listen: false)
          .loadBanners();
      setState(() {
        widget.onButtonPressed(false);
      });
    } catch (e) {
      setState(() {
        widget.onButtonPressed(false);
      });
      print("Ao remover a imgem deu isto:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.urlImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: confirmExc,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.delete,
                        size: 18,
                        color: Dadosgeralapp().tertiaryColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: confirmExc,
                    child: Container(
                      child: Text(
                        "Remover",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Dadosgeralapp().tertiaryColor,
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
          ],
        ),
      ),
    );
  }
}
