import 'package:flutter/material.dart';
import 'package:friotrim/funcoes/CriarContaeLogar.dart';
import 'package:friotrim/rotas/verificadorDeLogin.dart';
import 'package:provider/provider.dart';

class UsuarioNormalHome extends StatelessWidget {
  const UsuarioNormalHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async {
            Provider.of<CriarcontaelogarProvider>(context, listen: false)
                .deslogar();
            Navigator.of(context).push(DialogRoute(
              context: context,
              builder: (ctx) => VerificacaoDeLogado(),
            ));
          },
          child: Text("Usuario cliente logado"),
        ),
      ),
    );
  }
}
