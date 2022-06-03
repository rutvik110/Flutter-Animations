import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/galaxy_explorer/particle_system/bubble_stystem.dart';

class BublleSystemPainter extends CustomPainter {
  BublleSystemPainter({
    required this.bubbleSystem,
    required this.angle,
  }) : super(
          repaint: bubbleSystem,
        );

  BubbleSystem bubbleSystem;
  final double angle;
  @override
  void paint(Canvas canvas, Size size) {
    bubbleSystem.setCanvasSize(size);
    bubbleSystem.initWorld();
    canvas.drawPaint(
      Paint()..color = Colors.black,
    );

    canvas.translate(size.width / 2, size.height / 3);
    // canvas.rotate(angle);
    for (var i = 0; i < bubbleSystem.bubbles.length; i++) {
      final bubble = bubbleSystem.bubbles[i];
      final paint = Paint()..color = bubble.color;

      final center = bubble.position;
      // canvas.save();

      canvas.drawCircle(center, bubble.radius, paint);

      // canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
