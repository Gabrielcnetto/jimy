import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jimy/DadosGeralApp.dart';
import 'package:jimy/usuarioGerente/classes/servico.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:jimy/usuarioGerente/telas/visaoAvancadaIndicadores/itemViewServico.dart';
import 'package:jimy/usuarioGerente/telas/visaoAvancadaIndicadores/visaoServicosEscolhidos.dart';
import 'package:provider/provider.dart';

class TodosOsServicos extends StatefulWidget {
  const TodosOsServicos({super.key});

  @override
  State<TodosOsServicos> createState() => _TodosOsServicosState();
}

class _TodosOsServicosState extends State<TodosOsServicos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false).getListaServicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Todos os Serviços",
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
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: StreamBuilder(
                  stream: Provider.of<Getsdeinformacoes>(context, listen: true)
                      .getServiceList,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Dadosgeralapp().primaryColor,
                        ),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "Sem Serviços",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      List<Servico> listaServico =
                          snapshot.data as List<Servico>;

                      return Column(children: listaServico.map((item){
                        return ItemViewGeralServico(service: item,);
                      }).toList(),);
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
