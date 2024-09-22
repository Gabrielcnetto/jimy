import 'package:flutter/material.dart';
import 'package:fiotrim/usuarioGerente/telas/minhaPagina/editarWallpapers/editarWallpapers.dart';

class BannerItem extends StatefulWidget {
  List<String> images;
  BannerItem({
    super.key,
    required this.images,
  });

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              height: MediaQuery.of(context).size.height * 0.4,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.images[index],
                      fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 15,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => Editarwallpapers()));
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
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
              children: List.generate(widget.images.length, (index) {
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
    );
  }
}
