import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fiotrim/DadosGeralApp.dart';
import 'package:fiotrim/usuarioGerente/classes/CorteClass.dart';
import 'package:fiotrim/usuarioGerente/classes/barbeiros.dart';
import 'package:fiotrim/usuarioGerente/classes/produto.dart';
import 'package:fiotrim/usuarioGerente/classes/servico.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/telas/agendEaddScreen.dart/comanda/ComandaScreen.dart';
import 'package:fiotrim/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/ProdutoAdicionadoNaAgenda.dart';
import 'package:fiotrim/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/telaOndeMostraOsProdutos.dart';
import 'package:fiotrim/usuarioGerente/telas/agendEaddScreen.dart/editarAgendamento/telaOndeMostraOsServicos.dart';
import 'package:provider/provider.dart';

class AbrirApenasComanda extends StatefulWidget {
  const AbrirApenasComanda({super.key});

  @override
  State<AbrirApenasComanda> createState() => _AbrirApenasComandaState();
}

class _AbrirApenasComandaState extends State<AbrirApenasComanda> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Getsdeinformacoes>(context, listen: false)
        .getListaProfissionais();
    initMesAtual();
    loadloadIdBarbearia();
  }

  String? loadIdBarbearia;
  Future<void> loadloadIdBarbearia() async {
    String? id = await Getsdeinformacoes().getNomeIdBarbearia();

    setState(() {
      loadIdBarbearia = id;
    });
  }

  double porcentagemPorCortes = 100;
  double porcentagemPorProdutos = 100;
  String idDoServicoSelecionado = "";
  String urlImageProfissionalFoto = "";
  String idDoProfissional = "";
  String mesAtual = "";
  DateTime momento = DateTime.now();
  void initMesAtual() async {
    String monthName = await DateFormat('MMMM', 'pt_BR').format(momento);
    setState(() {
      mesAtual = monthName;
    });
  }

  double valorProdutosTotal = 0;
  double valorServicosTotal = 0;
  double valorComandaTotal = 0;
  List<Produtosavenda> _produtosAdicionados = [];
  void recebendoALista(List<Produtosavenda> produtos) {
    setState(() {
      _produtosAdicionados = produtos;
      SomandoValorTotal();
    });
  }

  void removeItem(Produtosavenda produto) {
    setState(() {
      _produtosAdicionados.remove(produto);
      SomandoValorTotal();
    });
  }

  void showScreenComProdutos() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => telaOndeMostraOsProdutos(
          onListaAdicionadosChanged: recebendoALista,
        ),
      ),
    );
  }

  void SomandoValorTotal() {
    double totalProdutos = 0; // Variável temporária para armazenar o total

    for (var item in _produtosAdicionados) {
      totalProdutos += item.preco; // Acumula o preço dos produtos
    }

    setState(() {
      valorProdutosTotal = totalProdutos; // Atualiza o valor total
      somandoAComandaTotal(); // Atualiza o total da comanda
    });
  }

  void somandoAComandaTotal() {
    setState(() {
      valorComandaTotal = (valorProdutosTotal + valorServicosTotal);
    });
  }

  //servicos:
  List<Servico> _servicosadicionados = [];
  void setandoServicoPadraoNaLista() {
    Servico item = Servico(
      quantiaEscolhida: 0,
      active: true,
      id: "",
      ocupar2vagas: false,
      name: "teste",
      price: 0,
    );
    setState(() {
      _servicosadicionados.add(item);
    });
  }

  void recebendoAListaDeServicos(List<Servico> ServicosItem) {
    setState(() {
      _servicosadicionados.addAll(ServicosItem);
      somandoServicosAMais();
    });
  }

  void removeServico(Servico servico) {
    setState(() {
      _servicosadicionados.remove(servico);
      somandoServicosAMais();
    });
  }

  void somandoServicosAMais() {
    double totalServicos = 0; // Inicia com o valor base do corte
    // Adiciona o valor de cada serviço adicional
    for (var item in _servicosadicionados) {
      totalServicos += item.price;
    }
    setState(() {
      valorServicosTotal =
          totalServicos; // Atualiza o valor total de serviços com base e adicionais
      somandoAComandaTotal(); // Atualiza o valor total da comanda
    });
  }

  void showScreenComServicos() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => TelaOndeMostraOsServicos(
          onListaAdicionadosChanged: recebendoAListaDeServicos,
          idDoServicoAtual: "",
        ),
      ),
    );
  }

  final nomeClienteControler = TextEditingController();

  String profSelecionado = "";
  int selectedIndexBarbeiros = -1;
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
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height * 0.14,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selecione o profissional",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                child: StreamBuilder(
                                  stream: Provider.of<Getsdeinformacoes>(
                                          context,
                                          listen: false)
                                      .getProfissionais,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Dadosgeralapp().primaryColor,
                                        ),
                                      );
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "Nenhum profissional encontrado",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<Barbeiros> listaBarbeiros =
                                        snapshot.data as List<Barbeiros>;
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: listaBarbeiros
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          Barbeiros item = entry.value;

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  profSelecionado = item.name;
                                                  selectedIndexBarbeiros =
                                                      index; // Atualiza o índice selecionado
                                                  idDoProfissional =
                                                      listaBarbeiros[index].id;
                                                  porcentagemPorCortes =
                                                      listaBarbeiros[index]
                                                          .porcentagemCortes;
                                                  porcentagemPorProdutos =
                                                      listaBarbeiros[index]
                                                          .porcentagemProdutos;
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.14,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.08,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        child: Image.network(
                                                          item.urlImageFoto ??
                                                              'https://example.com/default_avatar.jpg',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical:
                                                              5), // Espaço interno
                                                      decoration: BoxDecoration(
                                                        color: selectedIndexBarbeiros ==
                                                                index
                                                            ? Dadosgeralapp()
                                                                .tertiaryColor
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        item.name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                selectedIndexBarbeiros ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Nome do cliente",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Dadosgeralapp().secundariaColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Container(
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
                                  Icons.face,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Digite um nome';
                                      }
                                      return null;
                                    },
                                    controller: nomeClienteControler,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Produtos:",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (_produtosAdicionados.length == 0)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Text(
                                          "Vendeu algum produto?\nSome junto na comanda!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.grey.shade500,
                                      ),
                                    ],
                                  ),
                                ),
                              Column(
                                  children: _produtosAdicionados.map((item) {
                                return Dismissible(
                                  onDismissed: (direction) {
                                    // Remover o item da lista quando ele é deslizado
                                    removeItem(item);
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        "Remover",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Dadosgeralapp().tertiaryColor,
                                    ),
                                  ),
                                  key: Key(item.id),
                                  direction: DismissDirection.endToStart,
                                  child: ProdutoAdicionadoNaComanda(
                                    produto: item,
                                  ),
                                );
                              }).toList()),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: showScreenComProdutos,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Dadosgeralapp().primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Adicionar produto",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Serviços feitos:",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    if (_servicosadicionados.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            "Registre aqui\ncaso tenha feito algum serviço!",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (_servicosadicionados.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              _servicosadicionados.map((item) {
                                            bool isSingleItem =
                                                _servicosadicionados.length ==
                                                    1;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Dismissible(
                                                key: Key(item.id),
                                                onDismissed: (direction) {
                                                  // Remover o item da lista quando ele é deslizado
                                                  removeServico(item);
                                                },
                                                direction:
                                                    DismissDirection.endToStart,
                                                background: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Text(
                                                      "Remover",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Dadosgeralapp()
                                                        .tertiaryColor,
                                                  ),
                                                ),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "- ${item.name}",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade800,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "R\$${item.price.toStringAsFixed(2).replaceAll('.', ',')}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            color: Colors
                                                                .green.shade600,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: InkWell(
                                        onTap: showScreenComServicos,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Dadosgeralapp().primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Adicionar ou trocar serviço",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        width: 0.2,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Valor total da comanda:",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "R\$${valorComandaTotal.toStringAsFixed(2).replaceAll('.', ',')}",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //bloco da comanda - inicio
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ComandaScreen(
                                      produtosLista: _produtosAdicionados,
                                      servicoLista: _servicosadicionados,
                                      valorProdutoFinal: valorProdutosTotal,
                                      valorServicoFinal: valorServicosTotal,
                                      valorTotaldaComanda: valorComandaTotal,
                                      corte: Corteclass(
                                        porcentagemDoProfissional: 0,
                                        valorQueOProfissionalGanhaPorCortes:
                                            porcentagemPorCortes,
                                        valorQueOProfissionalGanhaPorProdutos:
                                            porcentagemPorProdutos,
                                        horariosExtras: [],
                                        idDoServicoSelecionado: "",
                                        nomeServicoSelecionado: "",
                                        JaCortou: false,
                                        MesSelecionado: mesAtual,
                                        ProfissionalSelecionado:
                                            profSelecionado,
                                        anoSelecionado:
                                            DateTime.now().year.toString(),
                                        barbeariaId: loadIdBarbearia!,
                                        clienteNome:
                                            "${nomeClienteControler.text}CmddCriada",
                                        dataSelecionadaDateTime: DateTime.now(),
                                        diaSelecionado:
                                            DateTime.now().day.toString(),
                                        horarioSelecionado: "",
                                        id: Random().nextDouble().toString(),
                                        momentoDoAgendamento: DateTime.now(),
                                        pagouPeloApp: false,
                                        pagoucomcupom: false,
                                        pontosGanhos: 0,
                                        preencher2horarios: false,
                                        profissionalId: idDoProfissional,
                                        urlImagePerfilfoto: Dadosgeralapp().defaultAvatarImage,
                                        urlImageProfissionalFoto:
                                            urlImageProfissionalFoto,
                                        valorCorte: 0,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      color: Dadosgeralapp().tertiaryColor,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Comanda",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 8,
                                          color: Dadosgeralapp().tertiaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //bloco da comanda - fim

                          //bloco do cancelar - inicio
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _servicosadicionados = [];
                                  _produtosAdicionados = [];
                                  selectedIndexBarbeiros = -1;
                                  valorProdutosTotal = 0;
                                  valorServicosTotal = 0;
                                  valorComandaTotal = 0;
                                  nomeClienteControler.text = "";
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cleaning_services,
                                      color: Dadosgeralapp().tertiaryColor,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Limpar Comanda",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 8,
                                          color: Dadosgeralapp().tertiaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //bloco do cancelar - fim
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
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
                        height: 5,
                      ),
                      Text(
                        "Criar comanda",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
