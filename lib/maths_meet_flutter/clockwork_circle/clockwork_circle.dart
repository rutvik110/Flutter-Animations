import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ClockWorkCircle extends StatefulWidget {
  const ClockWorkCircle({Key? key}) : super(key: key);

  @override
  State<ClockWorkCircle> createState() => _ClockWorkCircleState();
}

class _ClockWorkCircleState extends State<ClockWorkCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 10,
      ),
    )..repeat(reverse: true);
    animationController.addListener(() {
      setState(() {});
    });

    animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(
          curve: Curves.easeInOutExpo,
        ))
        .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            painter: ClockWorkCirclePainter(
              animationValue: animationController
                  .drive<double>(
                      Tween<double>(begin: 0, end: 1).chain(CurveTween(
                    curve: Curves.easeInOutExpo,
                  )))
                  .value,
              colorValue: animation.value,
            ),
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
          ),
        ],
      ),
    );
  }
}

class ClockWorkCirclePainter extends CustomPainter {
  ClockWorkCirclePainter({
    required this.animationValue,
    required this.colorValue,
  });
  final double animationValue;
  final double colorValue;
  @override
  void paint(Canvas canvas, Size size) {
    final paint2 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    const double innerLines = 6;
    const double radius = 20.0;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (var i = 1; i <= 12; i++) {
      final circleBrush = Paint()
        ..shader = RadialGradient(colors: [
          Colors.blue.withOpacity(0.1 * animationValue),
          Colors.red.withOpacity(0.1 * animationValue),
          Colors.purple.withOpacity(0.5 * animationValue),
        ], stops: const [
          0.0,
          0.6,
          0.9,
        ]).createShader(
          Rect.fromCircle(
            center: center,
            radius: radius * i,
          ),
        )
        ..style = PaintingStyle.fill;

      final angle = (pi * 2) / (innerLines * i);
      // final updatedAngle = angle + angle * 0.1;
      if (i < 12) {
        for (var j = 1; j <= innerLines * i; j++) {
          // final cosAngle = cos(angle * j + animationValue * i);
          // final sinAngle = sin(angle * j + animationValue * i);
          final cosAngle = cos(angle * j + animationValue * i);
          final sinAngle = sin(angle * j + animationValue * i);
          final innerCircleRadius = radius * i;
          final outerCircleRadius = radius * (i + 1);

          final x = size.width / 2 + cosAngle * innerCircleRadius;
          final y = size.height / 2 + sinAngle * innerCircleRadius;
          final startingPoint = Offset(x, y);
          final x2 = size.width / 2 + cosAngle * outerCircleRadius;
          final y2 = size.height / 2 + sinAngle * outerCircleRadius;
          final endPoint = Offset(x2, y2);
          canvas.drawLine(startingPoint, endPoint, paint2);
          canvas.drawCircle(endPoint, 2, paint2);
        }
      }

      canvas.drawCircle(center, radius * i, circleBrush);
      // canvas.drawRect(
      //   Rect.fromCircle(center: center, radius: radius * i),
      //   circleBrush,
      // );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
