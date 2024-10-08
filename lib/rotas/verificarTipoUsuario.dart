import 'package:Dimy/usuarioFuncionario/funcionarioHome.dart';
import 'package:flutter/material.dart';
import 'package:Dimy/DadosGeralApp.dart';
import 'package:Dimy/acesso/entrada/AcessoEntradaPrimeiraTela.dart';
import 'package:Dimy/funcoes/CriarContaeLogar.dart';
import 'package:Dimy/rotas/verificadorDeLogin.dart';
import 'package:Dimy/usuarioDistribuidor/UsuarioDistribuidorHome.dart';
import 'package:Dimy/usuarioGerente/UsuarioGerenteHome.dart';
import 'package:Dimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:Dimy/usuarioGerente/funcoes/CriarServicos.dart';
import 'package:Dimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:Dimy/usuarioNormal/UsuarioNormalHome.dart';
import 'package:provider/provider.dart';

class VerificartipoDeUsuario extends StatefulWidget {
  const VerificartipoDeUsuario({super.key});

  @override
  State<VerificartipoDeUsuario> createState() => _VerificartipoDeUsuarioState();
}

class _VerificartipoDeUsuarioState extends State<VerificartipoDeUsuario> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadUserIsManager();
    loadUseruserFuncionario();
    loadUseruserNormal();
    loadUserdistribuidor();
  }

  bool? isManager;
  Future<void> loadUserIsManager() async {
    bool? bolIsManager = await CriarcontaelogarProvider().getUserIsManager();

    setState(() {
      isManager = bolIsManager!;
    });
  }

  //

  bool? userNormal;
  Future<void> loadUseruserNormal() async {
    bool? booluserNormal =
        await CriarcontaelogarProvider().getUserIsUsuarioNormal();

    setState(() {
      userNormal = booluserNormal!;
    });
  }

  bool? distribuidor;
  Future<void> loadUserdistribuidor() async {
    bool? boldistribuidor =
        await CriarcontaelogarProvider().getUserIsUsuarioDistribuidor();

    setState(() {
      distribuidor = boldistribuidor!;
    });
  }
  bool? userFuncionario;
  Future<void> loadUseruserFuncionario() async {
    bool? boluserFuncionario =
        await CriarcontaelogarProvider().getUserIsUsuarioFuncionario();

    setState(() {
      userFuncionario = boluserFuncionario!;
    });
  }
  @override
  Widget build(BuildContext context) {
    // Verifica se as variáveis foram carregadas
    if (isManager == null || userNormal == null || distribuidor == null) {
      // Exibe um indicador de carregamento enquanto os dados são carregados
      return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              Provider.of<CriarcontaelogarProvider>(context, listen: false)
                  .deslogar();
              Navigator.of(context).push(DialogRoute(
                context: context,
                builder: (ctx) => VerificacaoDeLogado(),
              ));
            },
            child: Text('Carregando...'),
          ),
        ),
        body: Center(
            child: CircularProgressIndicator(
          color: Dadosgeralapp().primaryColor,
        )),
      );
    }

    // Exibindo a tela com base nas variáveis carregadas
    if (userNormal == true) {
      return UsuarioNormalHome();
    } else if (isManager == true) {
      return UsuarioGerenteHome(
        indexTela: 0,
      );
    } else if (distribuidor == true) {
      return UsuarioGerenteDistribuidor();
    } 
    else if(userFuncionario == true){
      return UsuarioFuncionarioHome();
    }
    else {
      return AcessoEntrada(); // aqui colocar uma tela default
    }
  }
}
