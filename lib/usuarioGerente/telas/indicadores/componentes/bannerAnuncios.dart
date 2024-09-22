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
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<String> _banners = [
    "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/bannerFixo%2FbannersHomeBarbeiros%2Fbanner02.png?alt=media&token=4a78540e-ebc6-4189-ae26-8efe60126f86",
    "https://firebasestorage.googleapis.com/v0/b/fiotrim.appspot.com/o/bannerFixo%2FbannersHomeBarbeiros%2Fbanner01.png?alt=media&token=9a2a614f-75e7-40e9-87c2-9e7d7a8fb101",
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              // Imagens no PageView
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _banners.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _banners[index],
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Indicador de bolinhas (dots)
              Positioned(
                bottom: 15, // Ajuste a posição vertical
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_banners.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == index ? 12.0 : 8.0,
                      height: _currentPage == index ? 12.0 : 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.grey.shade500.withOpacity(0.4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
