import 'dart:math';

import 'package:flutter/material.dart';

class EnlightenedHeart extends StatefulWidget {
  const EnlightenedHeart({Key? key}) : super(key: key);

  @override
  State<EnlightenedHeart> createState() => _EnlightenedHeartState();
}

class _EnlightenedHeartState extends State<EnlightenedHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: EnlightenedHeartPainter(
          animationValue: animationController.value,
          angleValue:
              Tween(begin: 0.0, end: pi * 2).animate(animationController).value,
        ),
        size: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}

class EnlightenedHeartPainter extends CustomPainter {
  EnlightenedHeartPainter({
    required this.animationValue,
    required this.angleValue,
  });
  final double animationValue;
  final double angleValue;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    const baseAngle = pi * 2 / 360;
    const visibleArc = baseAngle * 45;
    const edgeCaseAngle = 360 * baseAngle - visibleArc;
    double startAngle = angleValue;

    double endAngle = angleValue + visibleArc;
    const double heartRadius = 10;

    // Drawing group of circles which represent the  visible portion of hearts arc as animation progresses

    final angle = calculateAngleBasedOnPoints(360);

    final circlesGroup1 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    for (var i = 0; i < 360; i++) {
      //calculate the angle of point
      double pointAngleValue = angle * i;

      //check if pointAngleValue lies within start and end angle

      bool isInRange = checkIfPointInRange(
        pointAngleValue: pointAngleValue,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      if (!isInRange) {
        if (checkIfAngleGreaterThanEdgeCase(angle, edgeCaseAngle)) {
          isInRange = checkIfPointInRange(
            pointAngleValue: pointAngleValue + angle * 360,
            startAngle: startAngle,
            endAngle: endAngle,
          );
        }
      }

      if (isInRange) {
        canvas.drawCircle(
          calculatePointOffset(angle: pointAngleValue, radius: heartRadius),
          0.2,
          circlesGroup1,
        );
      }
    }

    // Drawing flickering small blue circles on the heart

    final circlesGroup2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    final angle2 = calculateAngleBasedOnPoints(45);

    for (var i = 0; i < 45; i++) {
      //calculate the angle of point
      double pointAngleValue = angle2 * i;

      //check if pointAngleValue lies within start and end angle

      bool isInRange = checkIfPointInRange(
        pointAngleValue: pointAngleValue,
        startAngle: startAngle,
        endAngle: endAngle,
      );
      if (!isInRange) {
        if (checkIfAngleGreaterThanEdgeCase(angle2, edgeCaseAngle)) {
          isInRange = checkIfPointInRange(
            pointAngleValue: pointAngleValue + angle * 360,
            startAngle: startAngle,
            endAngle: endAngle,
          );
        }
      }

      if (true) {
        final shouldFlicker = Random().nextBool();

        canvas.drawCircle(
          calculatePointOffset(angle: angle2 * i, radius: heartRadius),
          1 - animationValue + (shouldFlicker ? 0.9 : 0),
          circlesGroup2,
        );
      }
    }

    // Drawing flickering large blue circles on the heart

    final circlesGroup3 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    final angle3 = calculateAngleBasedOnPoints(10);

    for (var i = 0; i < 10; i++) {
      //calculate the angle of point
      double pointAngleValue = angle3 * i;

      //check if pointAngleValue lies within start and end angle

      bool isInRange = checkIfPointInRange(
        pointAngleValue: pointAngleValue,
        startAngle: startAngle,
        endAngle: endAngle,
      );

      if (!isInRange) {
        if (checkIfAngleGreaterThanEdgeCase(angle3, edgeCaseAngle)) {
          isInRange = checkIfPointInRange(
            pointAngleValue: pointAngleValue + angle * 360,
            startAngle: startAngle,
            endAngle: endAngle,
          );
        }
      }

      if (isInRange) {
        final shouldFlicker = Random().nextBool();

        canvas.drawCircle(
          calculatePointOffset(angle: angle3 * i, radius: heartRadius),
          3 + (shouldFlicker ? 0.7 : 0),
          circlesGroup3,
        );
      }
    }

    // Drawing group of circles which move along the  visible portion of hearts arc as animation progresses

    final circlesGroup4 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    for (var i = 0; i < 45; i++) {
      final updatedAngle = angleValue + 2.6 + (i / 10);
      canvas.drawCircle(
        calculatePointOffset(angle: updatedAngle, radius: heartRadius),
        i.toDouble() * 0.03,
        circlesGroup4,
      );
    }
  }

  bool checkIfPointInRange({
    required double pointAngleValue,
    required double startAngle,
    required double endAngle,
  }) {
    return pointAngleValue >= startAngle && pointAngleValue <= endAngle;
  }

  bool checkIfAngleGreaterThanEdgeCase(double angle, double edgeCaseAngle) {
    return angleValue >= edgeCaseAngle; //angle * 315;
  }

  double calculateAngleBasedOnPoints(int points) {
    return pi * 2 / points;
  }

  Offset calculatePointOffset({required double angle, required double radius}) {
    return Offset(
      16 * pow(sin(angle), 3) * radius,
      -radius *
          (13 * cos(angle) -
              5 * cos(angle * 2) -
              2 * cos(angle * 3) -
              cos(angle * 4)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
