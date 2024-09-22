import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/pagamentos.dart';
import 'package:fiotrim/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadTotal();
  }

  loadTotal() {
    loaduserNomeBarbearua();
    loaduseBarberDescription();
    loaduseBarberCEP();
    loaduseBarberCity();
    loaduseBarberStreetAndNumberAndBairro();
    getFormasPagamentoComoObjetos();
  }

  final nomeBarbeariaControler = TextEditingController();
  final descricaoBarbeariaControler = TextEditingController();
  final nomeRuaeNumeroControler = TextEditingController();
  final cepControler = TextEditingController();
  final cidadeControler = TextEditingController();
  List<Pagamentos> formasPagamento = pagListPrincipal;
  List<Pagamentos> _selectedItems = [];
  List<Pagamentos> listaInicialDB = [];
  Future<void> getFormasPagamentoComoObjetos() async {
    try {
      // Obtém a lista de mapas da função getFormasPagamento()
      List<Map<String, dynamic>> formasPagamentoMap =
          await Editprofilebarberpage().getFormasPagamento();

      // Converte a lista de mapas para uma lista de objetos Pagamentos
      List<Pagamentos> formasPagamento =
          formasPagamentoMap.map((map) => Pagamentos.fromMap(map)).toList();
      print("estou aqui no convert");
      print("${formasPagamento.toList()}");
      setState(() {
        _selectedItems = formasPagamento;
        listaInicialDB = formasPagamento;
      });
    } catch (e) {
      setState(() {
        _selectedItems = [];
      });
      print("Erro ao converter formas de pagamento: $e");
      throw e;
    }
  }

  String? BarbeariaNome;
  Future<void> loaduserNomeBarbearua() async {
    String? nomeBarbearia = await Getsdeinformacoes().getNomeBarbearia();

    setState(() {
      BarbeariaNome = nomeBarbearia;
      nomeBarbeariaControler.text = nomeBarbearia!;
    });
  }

  String descricaoBarbearia = "";
  Future<void> loaduseBarberDescription() async {
    String? descData = await Getsdeinformacoes().getDescricaoBarbearia();

    setState(() {
      if (descData != null) {
        descricaoBarbeariaControler.text = descData;
        descricaoBarbearia = descData;
      } else {
        descricaoBarbeariaControler.text = "Descrição não disponível";
      }
    });
  }

  String? cepBarbearia;
  Future<void> loaduseBarberCEP() async {
    String? descData = await Getsdeinformacoes().getCEPbarbearia();

    setState(() {
      if (descData != null) {
        cepControler.text = descData;
        cepBarbearia = descData;
      } else {
        cepControler.text = "Descrição não disponível";
      }
    });
  }

  String? cidadeBarbearia;
  Future<void> loaduseBarberCity() async {
    String? descData = await Getsdeinformacoes().getCidadebarbearia();

    setState(() {
      if (descData != null) {
        cidadeControler.text = descData;
        cidadeBarbearia = descData;
      } else {
        cidadeControler.text = "Ciddade não disponível";
      }
    });
  }

  String? enderecoRuaemais;
  Future<void> loaduseBarberStreetAndNumberAndBairro() async {
    String? descData = await Getsdeinformacoes().getEnderecobarbearia();

    setState(() {
      if (descData != null) {
        nomeRuaeNumeroControler.text = descData;
        enderecoRuaemais = descData;
      } else {
        nomeRuaeNumeroControler.text = "Endereço não disponível";
      }
    });
  }

  Future<void> atualizarInfs() async {
    try {
      setState(() {
        isLoading = true;
      });
      print("entrei aqui #1");
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .addPayments(
        pagamentos: _selectedItems,
      );

      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .attNomeBarbearia(
        NovoNome: nomeBarbeariaControler.text,
      );
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .attDescricaoBarbearia(
        novaDescricao: descricaoBarbeariaControler.text,
      );
      await Provider.of<Editprofilebarberpage>(context, listen: false)
          .attBairroRuaENumeroBarbearia(
        endereco: nomeRuaeNumeroControler.text,
      );
       await Provider.of<Editprofilebarberpage>(context, listen: false)
          .attCEP(
        CEP: cepControler.text.replaceAll('-', '').replaceAll(' ', ''),
      );
        await Provider.of<Editprofilebarberpage>(context, listen: false)
          .attCidade(
        Cidade: cidadeControler.text,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erro ao atualizar o nome $e");
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Edite seu perfil para clientes",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome da Barbearia",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: nomeBarbeariaControler,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adicione uma Descrição",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Dadosgeralapp().secundariaColor,
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
                                      5, // Permite que o campo expanda verticalmente
                                  minLines: 1,
                                  controller: descricaoBarbeariaControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Descreva sua barbearia para clientes",
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Formas de pagamento",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: formasPagamento.map(
                                    (item) {
                                      bool isSelected = _selectedItems.any(
                                          (selectedItem) =>
                                              selectedItem.id == item.id);

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              // Remove o item selecionado com base no ID
                                              _selectedItems.removeWhere(
                                                  (selectedItem) =>
                                                      selectedItem.id ==
                                                      item.id);
                                            } else {
                                              // Adiciona o item se ele não estiver na lista de selecionados
                                              _selectedItems.add(item);
                                            }
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: isSelected
                                                      ? Dadosgeralapp().tertiaryColor
                                                      : Colors.grey.shade50,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: Image.network(
                                                        item.photoIcon,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${item.name}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Colors.black38,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      Text(
                        "Informações do endereço:",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome da rua, Bairo e Nº",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: nomeRuaeNumeroControler,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CEP",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.pin,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: cepControler,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
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
                            "Cidade",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: cidadeControler,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          atualizarInfs();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Dadosgeralapp().primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Atualizar agora",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
      ),
    );
  }
}
