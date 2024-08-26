import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jimy/acesso/entrada/AcessoEntradaPrimeiraTela.dart';
import 'package:jimy/firebase_options.dart';
import 'package:jimy/funcoes/CriarContaeLogar.dart';
import 'package:jimy/rotas/AppRoutes.dart';
import 'package:jimy/rotas/verificadorDeLogin.dart';
import 'package:jimy/usuarioGerente/funcoes/CriarFuncionario.dart';
import 'package:jimy/usuarioGerente/funcoes/CriarServicos.dart';
import 'package:jimy/usuarioGerente/funcoes/GetsDeInformacoes.dart';
import 'package:provider/provider.dart';

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
     
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jimy App',
        routes: {
          Approutes.VerificacaoDeLogado: (ctx) => VerificacaoDeLogado(),
        },
      ),
    );
  }
}
