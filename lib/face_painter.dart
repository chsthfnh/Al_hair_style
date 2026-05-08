import 'dart:math';
import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  final List<Point<int>> points;
  final Size imageSize;
  FacePainter(this.points, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = Colors.tealAccent
      ..style = PaintingStyle.fill;
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    for (var p in points) {
      canvas.drawCircle(Offset(p.x * scaleX, p.y * scaleY), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => true;
}
