import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerAnunciosPerfilGerente extends StatefulWidget {
  const BannerAnunciosPerfilGerente({super.key});

  @override
  State<BannerAnunciosPerfilGerente> createState() =>
      _BannerAnunciosPerfilGerenteState();
}

class _BannerAnunciosPerfilGerenteState
    extends State<BannerAnunciosPerfilGerente> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width,
          maxHeight: 250,
        ),
        child: CarouselView(
          
          itemSnapping: true,
          itemExtent: 300,
          children: [
            Hero(
              transitionOnUserGestures: true,
              tag: 'image-1',
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/friotrimappoficial.appspot.com/o/bannersTest%2Fbanner%201%20app%20(1).png?alt=media&token=4ba14c2a-459b-47a0-8767-4a556d8daf6b",
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
              ),
            ),
            Hero(
              tag: 'image-1',
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/friotrimappoficial.appspot.com/o/bannersTest%2Fbanner%202.png?alt=media&token=8a06b03c-b7f9-48dc-afc9-b6091bd6d2a7",
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
              ),
            ),
            Hero(
              tag: 'image-1',
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/friotrimappoficial.appspot.com/o/bannersTest%2Fbanner%203.png?alt=media&token=220fbdc4-63bc-4810-844a-8d1aca23ced1",
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
