import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friotrim/acesso/entrada/AcessoEntradaPrimeiraTela.dart';
import 'package:friotrim/firebase_options.dart';
import 'package:friotrim/funcoes/CriarContaeLogar.dart';
import 'package:friotrim/funcoes/agendarHorario.dart';
import 'package:friotrim/rotas/AppRoutes.dart';
import 'package:friotrim/rotas/verificadorDeLogin.dart';
import 'package:friotrim/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:friotrim/usuarioGerente/funcoes/CriarServicos.dart';
import 'package:friotrim/usuarioGerente/funcoes/EditProfileBarberPage.dart';
import 'package:friotrim/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:friotrim/usuarioGerente/funcoes/ajusteHorarios.dart';
import 'package:friotrim/usuarioGerente/funcoes/configurarPontos.dart';
import 'package:friotrim/usuarioGerente/funcoes/criar_e_enviarProdutos.dart';
import 'package:friotrim/usuarioGerente/funcoes/despesas.dart';
import 'package:friotrim/usuarioGerente/funcoes/finalizareCarregarComandas.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Chame primeiro aqui ele inicia os widgets
  //so apos dar o start, ele inicia o firebase, aqui o app ja esta carregado e funcionando
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProvider(create: (_)=>Ajustehorarios(),),
        ChangeNotifierProvider(create: (_)=>Configurarpontos(),),
      ],
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'friotrim App',
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
