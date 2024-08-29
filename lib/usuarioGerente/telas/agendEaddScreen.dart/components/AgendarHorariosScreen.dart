import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/barbeiros.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class AgendarHorarioScreen extends StatefulWidget {
  const AgendarHorarioScreen({super.key});

  @override
  State<AgendarHorarioScreen> createState() => _AgendarHorarioScreenState();
}

class _AgendarHorarioScreenState extends State<AgendarHorarioScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).getListaServicos();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
  }

  final numberControler = TextEditingController();
  final nomeClienteControler = TextEditingController();

  bool verServicos = true;
  void loadListAndView() async {
    await Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaServicos();
    await Provider.of<Getsdeinformacoes>(context, listen: false)
        .serviceListStream;
    setState(() {
      verServicos = !verServicos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      "Agende um horário",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Aqui você pode agendar horários para os seus clientes. Recomende o App do ${Dadosgeralapp().nomeSistema} para o próprio cliente agendar!",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Dadosgeralapp().cinzaParaSubtitulosOuDescs,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //container do nome do cliente
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Dadosgeralapp().primaryColor),
                            child: const Text(
                              "1",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Nome do cliente",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        child: TextFormField(
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          controller: nomeClienteControler,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Container do contato
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Dadosgeralapp().primaryColor),
                            child: const Text(
                              "2",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Telefone de contato",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "(Não obrigatório)",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black38,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        child: TextFormField(
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          controller: numberControler,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //fim container contato
                  //Container serviços
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Dadosgeralapp().primaryColor),
                          child: const Text(
                            "3",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(54, 54, 54, 1),
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Seus serviços",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: InkWell(
                                      onTap: () {
                                        Provider.of<Getsdeinformacoes>(context,
                                                listen: false)
                                            .getListaServicos();
                                        Provider.of<Getsdeinformacoes>(context,
                                                listen: false)
                                            .serviceListStream;
                                        setState(() {
                                          verServicos = !verServicos;
                                        });
                                      },
                                      child: Icon(
                                        verServicos == false
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_drop_up,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (verServicos == true)
                                StreamBuilder(
                                  stream: Provider.of<Getsdeinformacoes>(
                                          context,
                                          listen: false)
                                      .getServiceList,
                                  builder: (ctx, snaphost) {
                                    if (snaphost.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Dadosgeralapp().primaryColor,
                                        ),
                                      );
                                    }
                                    if (!snaphost.hasData ||
                                        snaphost.data!.isEmpty ||
                                        snaphost.data == null) {
                                      return Center(
                                        child: Text(
                                          "Sem serviços Cadastrados",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<Servico> listaServico =
                                        snaphost.data as List<Servico>;
                                    return Column(
                                      children: listaServico.map((servicoItem) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${servicoItem.name} - ",
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .green.shade600,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Icon(
                                                        Icons.paid,
                                                        size: 12,
                                                        color: Color.fromRGBO(
                                                            54, 54, 54, 1),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      "R\$${servicoItem.price.toStringAsFixed(2).replaceAll('.', ',')}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: Colors.white38,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.toggle_off,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Dadosgeralapp().primaryColor),
                        child: const Text(
                          "4",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Selecione o profissional",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  StreamBuilder(
                    stream:
                        Provider.of<Getsdeinformacoes>(context, listen: false)
                            .getProfissionais,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: Dadosgeralapp().primaryColor,
                        );
                      }
                      if (!snapshot.hasData ||
                          snapshot.data!.isEmpty ||
                          snapshot.data == null) {
                        return Center(
                          child: Text(
                            "Sem profissionais Cadastrados",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      List<Barbeiros> listaBarbeiros =
                          snapshot.data as List<Barbeiros>;
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Define a altura de cada item
                            double itemHeight =
                                MediaQuery.of(context).size.height * 0.7;
                            // Calcula o número de linhas necessárias
                            int rows = (listaBarbeiros.length / 2)
                                .ceil(); // Assume 2 colunas
                            // Calcula a altura total necessária para o GridView
                            double totalHeight = rows * itemHeight +
                                (rows - 1) *
                                    10.0; // Considera o espaçamento entre linhas

                            return Container(
                              height:
                                  totalHeight, // Altura total calculada do Container
                              child: GridView.builder(
                                physics:
                                    NeverScrollableScrollPhysics(), // Desativa o scroll do GridView
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (itemHeight + 10.0),
                                ),
                                itemCount: listaBarbeiros
                                    .length, // Substitua pelo tamanho da sua lista
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: itemHeight,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            listaBarbeiros[index].urlImageFoto,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
