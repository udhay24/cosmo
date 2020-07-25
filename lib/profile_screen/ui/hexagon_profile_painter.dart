import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class HexagonProfilePainter extends CustomPainter {
  ui.Image image;

  HexagonProfilePainter({@required this.image});

  @override
  void paint(Canvas canvas, Size size) async {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.black;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);

    canvas.drawImage(image, Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
