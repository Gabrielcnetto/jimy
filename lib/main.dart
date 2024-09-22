import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiotrim/acesso/entrada/AcessoEntradaPrimeiraTela.dart';
import 'package:fiotrim/firebase_options.dart';
import 'package:fiotrim/funcoes/CriarContaeLogar.dart';
import 'package:fiotrim/funcoes/agendarHorario.dart';
import 'package:fiotrim/rotas/AppRoutes.dart';
import 'package:fiotrim/rotas/verificadorDeLogin.dart';
import 'package:fiotrim/usuarioDistribuidor/funcoes/produtosFunctions.dart';
import 'package:fiotrim/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:fiotrim/usuarioGerente/funcoes/CriarServicos.dart';
import 'package:fiotrim/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:fiotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:fiotrim/usuarioGerente/funcoes/ajusteHorarios.dart';
import 'package:fiotrim/usuarioGerente/funcoes/configurarPontos.dart';
import 'package:fiotrim/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:fiotrim/usuarioGerente/funcoes/despesas.dart';
import 'package:fiotrim/usuarioGerente/funcoes/finalizareCarregarComandas.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Chame primeiro aqui ele inicia os widgets
  //so apos dar o start, ele inicia o firebase, aqui o app ja esta carregado e funcionando
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CriarcontaelogarProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Criarfuncionario(),
        ),
        ChangeNotifierProvider(
          create: (_) => Getsdeinformacoes(),
        ),
        ChangeNotifierProvider(
          create: (_) => Criarservicos(),
        ),
        ChangeNotifierProvider(
          create: (_) => Agendarhorario(),
        ),
        ChangeNotifierProvider(
          create: (_) => CriarEEnviarprodutos(),
        ),
        ChangeNotifierProvider(
          create: (_) => Finalizarecarregarcomandas(),
        ),
        ChangeNotifierProvider(
          create: (_) => DespesasFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => Editprofilebarberpage(),
        ),
        ChangeNotifierProvider(
          create: (_) => Ajustehorarios(),
        ),
        ChangeNotifierProvider(
          create: (_) => Configurarpontos(),
        ),
        ChangeNotifierProvider(
          create: (_) => Produtosfunctions(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'fiotrim App',
        routes: {
          Approutes.VerificacaoDeLogado: (ctx) => VerificacaoDeLogado(),
        },
        supportedLocales: const [
          Locale('pt', 'BR'), // Português do Brasil
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            cancelButtonStyle: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            confirmButtonStyle: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
