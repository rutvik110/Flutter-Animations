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
    final smallcircles = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.translate(size.width / 2, size.height / 2);

    const angle = pi * 2 / 360;
    for (var i = 0; i < 360; i++) {
      final itemValue = i / 360;
      //calculate the angle of point
      double pointAngleValue = angle * i;
      double startAngle = angleValue;
      double endAngle = angleValue + angle * 45;

      //check if pointAngleValue lies within start and end angle

      bool isInRange =
          pointAngleValue >= startAngle && pointAngleValue <= endAngle;

      if (!isInRange) {
        if (angleValue >= angle * 315) {
          isInRange = pointAngleValue + angle * 360 >= startAngle &&
              pointAngleValue + angle * 360 <= endAngle;
        }
      }

      if (isInRange) {
        // dev.log((i % 45).toString());
        final radius = ((i % 45) / 45) * 0.3;
        // dev.log(radius.toString());
        canvas.drawCircle(
          Offset(
            16 * pow(sin(pointAngleValue), 3) * 15,
            -15 *
                (13 * cos(pointAngleValue) -
                    5 * cos(pointAngleValue * 2) -
                    2 * cos(pointAngleValue * 3) -
                    cos(pointAngleValue * 4)),
          ),
          0.2, // radius == 0 ? 0.1 : radius + 0.1,
          smallcircles,
        );
      }
    }

    final smallcircles2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    const angle2 = pi * 2 / 45;

    for (var i = 0; i < 45; i++) {
      final itemValue = i / 45;
      //calculate the angle of point
      double pointAngleValue = angle2 * i;
      double startAngle = angleValue;
      double endAngle = angleValue + angle * 45;

      //check if pointAngleValue lies within start and end angle

      bool isInRange =
          pointAngleValue >= startAngle && pointAngleValue <= endAngle;

      if (!isInRange) {
        if (angleValue >= angle2 * 315) {
          isInRange = pointAngleValue + angle * 360 >= startAngle &&
              pointAngleValue + angle * 360 <= endAngle;
        }
      }
      // final isInRange =
      //     itemValue > animationValue - 0.1 && itemValue < animationValue + 0.1;
      if (isInRange) {
        final shouldFlicker = Random().nextBool();

        canvas.drawCircle(
          Offset(
            16 * pow(sin(angle2 * i), 3) * 15,
            -15 *
                (13 * cos(angle2 * i) -
                    5 * cos(angle2 * i * 2) -
                    2 * cos(angle2 * i * 3) -
                    cos(angle2 * i * 4)),
          ),
          itemValue - animationValue + (shouldFlicker ? 0.9 : 0),
          smallcircles2,
        );
      }
    }
    final smallcircles3 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    const angle3 = pi * 2 / 10;

    for (var i = 0; i < 10; i++) {
      final itemValue = i / 10;
      //calculate the angle of point
      double pointAngleValue = angle3 * i;
      double startAngle = angleValue;
      double endAngle = angleValue + angle * 45;

      //check if pointAngleValue lies within start and end angle

      bool isInRange =
          pointAngleValue >= startAngle && pointAngleValue <= endAngle;

      if (!isInRange) {
        if (angleValue >= angle3 * 315) {
          isInRange = pointAngleValue + angle * 360 >= startAngle &&
              pointAngleValue + angle * 360 <= endAngle;
        }
      }
      // final isInRange =
      //     itemValue > animationValue - 0.1 && itemValue < animationValue + 0.1;
      final shouldFlicker = Random().nextBool();
      if (isInRange) {
        canvas.drawCircle(
          Offset(
            16 * pow(sin(angle3 * i), 3) * 15,
            -15 *
                (13 * cos(angle3 * i) -
                    5 * cos(angle3 * i * 2) -
                    2 * cos(angle3 * i * 3) -
                    cos(angle3 * i * 4)),
          ),
          3 + (shouldFlicker ? 0.7 : 0),
          smallcircles3,
        );
      }
    }

    final activeCircle = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    for (var i = 0; i < 5; i++) {
      final updatedAngle = angleValue + 0.4 + (i / 10);
      canvas.drawCircle(
        Offset(
          16 * pow(sin(updatedAngle), 3) * 15,
          -15 *
              (13 * cos(updatedAngle) -
                  5 * cos(updatedAngle * 2) -
                  2 * cos(updatedAngle * 3) -
                  cos(updatedAngle * 4)),
        ),
        i.toDouble() / 2,
        activeCircle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
