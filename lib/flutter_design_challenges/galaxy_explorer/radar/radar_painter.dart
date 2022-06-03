import 'dart:math';

import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  RadarPainter({
    required this.angle,
  });
  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    // draw a circular radar at the center
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.white
      ..shader = SweepGradient(
        transform: GradientRotation(angle),
        colors: [
          Colors.black.withOpacity(0.4),
          const Color.fromARGB(255, 46, 100, 49).withOpacity(0.4),
          const Color.fromARGB(255, 71, 234, 76).withOpacity(0.4),
        ],
        stops: const [
          0.0,
          0.75,
          1.0,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      )
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, paint);
    final backdropRadarBlur = Paint()
      ..color = Colors.white
      ..shader = RadialGradient(
        transform: GradientRotation(angle),
        radius: 0.7,
        colors: [
          const Color.fromARGB(255, 46, 100, 49),
          Colors.black.withOpacity(0.4),
        ],
        stops: const [
          0.0,
          1.0,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );
    canvas.drawCircle(center, radius, backdropRadarBlur);
    final unitRadius = radius / 5;

    for (var i = 0; i < 5; i++) {
      final paint2 = Paint()
        ..color = i == 4 ? Colors.green : Colors.green[700]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == 4 ? 6 : 1;
      final circleradius = unitRadius * (i + 1);
      canvas.drawCircle(center, circleradius, paint2);
    }

    //draw 60 lines at edges of circle in 360 degree

    const unitAngle = pi * 2 / 60;
    for (var i = 0; i < 60; i++) {
      final minorPaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final majorPaint = Paint()
        ..color = Colors.green[700]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      final angle = i * unitAngle;

      final isMajor = angle % (pi / 2) == 0;

      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final lineLength = isMajor ? 15 : 8;
      final end = Offset(
        center.dx + (radius - lineLength) * cos(angle),
        center.dy + (radius - lineLength) * sin(angle),
      );
      canvas.drawLine(
        start,
        end,
        isMajor ? majorPaint : minorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
