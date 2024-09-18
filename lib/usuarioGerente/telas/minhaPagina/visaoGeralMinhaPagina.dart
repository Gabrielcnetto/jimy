import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/minhaPagina/components/profItemDaLista.dart';
import 'package:jimy/usuarioGerente/telas/minhaPagina/editarPerfil/EditarPerfilScreen.dart';
import 'package:provider/provider.dart';

class VisaoGeralMinhaPagina extends StatefulWidget {
  const VisaoGeralMinhaPagina({super.key});

  @override
  State<VisaoGeralMinhaPagina> createState() => _VisaoGeralMinhaPaginaState();
}

class _VisaoGeralMinhaPaginaState extends State<VisaoGeralMinhaPagina> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
  }

  List<String> _images = [
    "https://images.squarespace-cdn.com/content/v1/5fd787d32a8a4a2604b22b5d/a1a982a2-8886-4017-a735-3fde5aeab145/msbs-barbershop-perspective-22000.jpg",
    "https://images.squarespace-cdn.com/content/v1/5fd787d32a8a4a2604b22b5d/a1a982a2-8886-4017-a735-3fde5aeab145/msbs-barbershop-perspective-22000.jpg",
    "https://images.squarespace-cdn.com/content/v1/5fd787d32a8a4a2604b22b5d/a1a982a2-8886-4017-a735-3fde5aeab145/msbs-barbershop-perspective-22000.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        itemCount: _images.length,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            _images[index],
                            fit: BoxFit.cover,
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
                            size: 18,
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
                      children: List.generate(_images.length, (index) {
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "Netto Barbershop",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.verified,
                                color: Colors.blue.shade600,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.yellow.shade600,
                              ),
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.yellow.shade600,
                              ),
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.yellow.shade600,
                              ),
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.yellow.shade600,
                              ),
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.yellow.shade600,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text("5.0"),
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EditarPerfilScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Dadosgeralapp().primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "Editar perfil",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      height: 1,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profissionais disponíveis",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: StreamBuilder(
                            stream: Provider.of<Getsdeinformacoes>(context,
                                    listen: false)
                                .getProfissionais,
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Dadosgeralapp().primaryColor,
                                  ),
                                );
                              }
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "Sem profissionais",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.hasData) {
                                List<Barbeiros> _barberList =
                                    snapshot.data as List<Barbeiros>;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _barberList.map((barber) {
                                      return ProfItemDaLista(
                                        barber: barber,
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      height: 1,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Descrição da Barbearia:",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Somos da Netto Barbershop, combinamos excelencia com comodidade. Preços acessíveis e perto você. Agende seu horário!",
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.black38, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Horários de funcionamento",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "COLOCAR LISTA ROW AQUI",
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.black38, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Formas de pagamento",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "COLOCAR EDITAVEL AQUI COM OS CARTOES E ICONES",
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.black38, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Endereço",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "COLOCAR TEXTO + MAPA APPLE E GOOGLE ABAIXO",
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.black38, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
