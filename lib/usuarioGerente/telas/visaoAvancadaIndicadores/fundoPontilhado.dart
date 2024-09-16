
import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final double dashWidth; // Largura de cada segmento da linha
  final double dashSpace; // Espaço entre os segmentos da linha
  final double strokeWidth; // Largura da linha

  DottedLinePainter({
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade200.withOpacity(0.5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    // Desenhar linhas pontilhadas na vertical
    double startY = 0;
    while (startY < size.height) {
      // Adicionar linha pontilhada
      for (double x = 0; x < size.width; x += dashWidth + dashSpace) {
        path.moveTo(x, startY);
        path.lineTo(x + dashWidth, startY);
      }
      startY += dashWidth + dashSpace; // Avançar para a próxima linha
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
