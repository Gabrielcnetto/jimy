import 'package:flutter/material.dart';

class VisaoGeralMinhaPagina extends StatefulWidget {
  const VisaoGeralMinhaPagina({super.key});

  @override
  State<VisaoGeralMinhaPagina> createState() => _VisaoGeralMinhaPaginaState();
}

class _VisaoGeralMinhaPaginaState extends State<VisaoGeralMinhaPagina> {
  final imagemBaseTest =
      "https://images.squarespace-cdn.com/content/v1/5fd787d32a8a4a2604b22b5d/a1a982a2-8886-4017-a735-3fde5aeab145/msbs-barbershop-perspective-22000.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.network(
                        imagemBaseTest,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: Colors.black.withOpacity(
                          0.45), // Ajuste a opacidade conforme necessário
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.ios_share,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
