import 'package:flutter/material.dart';

class BannerAnunciosPerfilGerente extends StatelessWidget {
  const BannerAnunciosPerfilGerente({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10),
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.green,
      ),
    );
  }
}