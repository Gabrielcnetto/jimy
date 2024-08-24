import 'package:flutter/material.dart';
import 'package:jimy/funcoes/CriarContaeLogar.dart';
import 'package:jimy/rotas/verificadorDeLogin.dart';
import 'package:provider/provider.dart';

class UsuarioGerenteHome extends StatelessWidget {
  const UsuarioGerenteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            Provider.of<CriarcontaelogarProvider>(context, listen: false)
                .deslogar();
            Navigator.of(context).push(DialogRoute(
              context: context,
              builder: (ctx) => VerificacaoDeLogado(),
            ));
          },
          child: Text("deslogar"),
        ),
      ),
    );
  }
}
