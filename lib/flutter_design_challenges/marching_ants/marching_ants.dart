import 'dart:ui';

import 'package:flutter/material.dart';

class MarchingAnts extends StatefulWidget {
  const MarchingAnts({Key? key}) : super(key: key);

  @override
  State<MarchingAnts> createState() => _MarchingAntsState();
}

class _MarchingAntsState extends State<MarchingAnts>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(300, 300),
                  painter: MarchingAntsPainter(
                    animation.value,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MarchingAntsPainter extends CustomPainter {
  MarchingAntsPainter(this.value);
  final double value;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final outerLayer = Path()
      ..moveTo(value * 50, size.height / 2)
      ..lineTo(size.width * 0.25, size.height / 2)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width * 0.75, size.height / 2)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width * 0.75, size.height)
      ..lineTo(size.width * 0.25, size.height)
      ..lineTo(0, size.height / 2)
      ..lineTo(value * 50, size.height / 2);

//outer layer
    Path dashPath = Path();

    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0;

    for (PathMetric pathMetric in outerLayer.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(
            distance,
            distance + dashWidth,
          ),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
    //finish
//inner layer
    final size2 = Size(size.width * 0.9, size.width * 0.9);
    final innerLayer = Path()
      ..moveTo(value * 50, size2.height / 2)
      ..lineTo(size2.width * 0.25, size2.height / 2)
      ..lineTo(size2.width / 2, 0)
      ..lineTo(size2.width * 0.75, size2.height / 2)
      ..lineTo(size2.width, size2.height / 2)
      ..lineTo(size2.width * 0.75, size2.height)
      ..lineTo(size2.width * 0.25, size2.height)
      ..lineTo(0, size2.height / 2)
      ..lineTo(value * 50, size2.height / 2);
    final shiftedLayer = innerLayer.shift(const Offset(15, 20));
    Path dashPath2 = Path();

    double distance2 = 0;

    for (PathMetric pathMetric in shiftedLayer.computeMetrics()) {
      while (distance2 < pathMetric.length) {
        dashPath2.addPath(
          pathMetric.extractPath(
            distance2,
            distance2 + dashWidth,
          ),
          Offset.zero,
        );
        distance2 += dashWidth;
        distance2 += dashSpace;
      }
    }

    canvas.drawPath(dashPath2, paint);
    //finish
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
