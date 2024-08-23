import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jimy/acesso/entrada/AcessoEntradaPrimeiraTela.dart';
import 'package:jimy/rotas/verificarTipoUsuario.dart';

class VerificacaoDeLogado extends StatelessWidget {
  const VerificacaoDeLogado({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snpshot) {
        if (snpshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snpshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
           Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext ctx) {
                  return const VerificartipoDeUsuario();
                },
              ),
              (Route<dynamic> route) =>
                  false, // Remove todas as rotas anteriores
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //Navigator.of(context).pushNamed(AppRoutesApp.InitialScreenApp);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext ctx) {
                  return const AcessoEntrada();
                },
              ),
              (Route<dynamic> route) =>
                  false, // Remove todas as rotas anteriores
            );
          });
        }
        return Container();
      },
    );
  }
}
