import 'dart:math';
import 'dart:ui';

import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

double angle = 18 * (pi / 180);
Color bgColor = bgColors[0];
final bgColors = [
  const Color.fromARGB(255, 208, 208, 208),
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.brown,
  Colors.indigo,
  Colors.black,
];

class FlutterShadows extends StatefulWidget {
  const FlutterShadows({super.key});

  @override
  State<FlutterShadows> createState() => _FlutterShadowsState();
}

class _FlutterShadowsState extends State<FlutterShadows> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //create a grid of 10 different colors

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 300,
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    for (int i = 0; i < bgColors.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            bgColor = bgColors[i];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColors[i],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),

            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text((angle / (pi / 180)).toStringAsFixed(0)),
                SizedBox(
                  width: 300,
                  child: Slider(
                    value: angle,
                    max: pi / 4,
                    min: 0,
                    divisions: 360,
                    onChanged: (value) {
                      setState(() {
                        angle = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ShadowPainter(
                          Devices.ios.iPhone13ProMax.borderRadius,
                          Devices.ios.iPhone13ProMax.frameSize,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: DeviceFrame(
                        device: Devices.ios.iPhone13ProMax,
                        screen: const ColoredBox(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShadowPainter extends CustomPainter {
  final double borderRadius;
  ShadowPainter(
    this.borderRadius,
    this.frameSize,
  );
  final Size frameSize;
  @override
  void paint(Canvas canvas, Size size) {
    final newBorderRadius = (borderRadius / frameSize.width) * size.width;

    final rounredRect = RRect.fromRectAndRadius(
      const Offset(
            0,
            0,
          ) &
          size,
      Radius.circular(newBorderRadius),
    );

    final width = size.width;
    final height = size.height;
    final topRightCorner = Offset(width - rounredRect.trRadiusX / 1.2, 0);
    final bottomRightCorner = Offset(width, height);
    final bottomLeftCorner = Offset(rounredRect.blRadiusX / 1.28, height);
    Offset topRightCornerBelowPoint = Offset(width * 4, 110);
    // rotate the point (topRightCornerBelowPoint) by [angle] taking the topRightCorner
    // as the center of rotation
    topRightCornerBelowPoint = Offset(
      cos(angle) * (topRightCornerBelowPoint.dx - topRightCorner.dx) -
          sin(angle) * (topRightCornerBelowPoint.dy - topRightCorner.dy) +
          topRightCorner.dx,
      sin(angle) * (topRightCornerBelowPoint.dx - topRightCorner.dx) +
          cos(angle) * (topRightCornerBelowPoint.dy - topRightCorner.dy) +
          topRightCorner.dy,
    );
    Offset bottomLeftCornerBelowPOint = Offset(width * 4, height + 110);
    // rotate the point (bottomLeftCornerBelowPOint) by [angle] taking the bottomLeftCorner
    // as the center of rotation

    bottomLeftCornerBelowPOint = Offset(
      cos(angle) * (bottomLeftCornerBelowPOint.dx - bottomLeftCorner.dx) -
          sin(angle) * (bottomLeftCornerBelowPOint.dy - bottomLeftCorner.dy) +
          bottomLeftCorner.dx,
      sin(angle) * (bottomLeftCornerBelowPOint.dx - bottomLeftCorner.dx) +
          cos(angle) * (bottomLeftCornerBelowPOint.dy - bottomLeftCorner.dy) +
          bottomLeftCorner.dy,
    );

    final path = Path()
      ..moveTo(topRightCorner.dx, topRightCorner.dy)
      ..lineTo(bottomRightCorner.dx, bottomRightCorner.dy)
      ..lineTo(bottomLeftCorner.dx, bottomLeftCorner.dy)
      ..lineTo(bottomLeftCornerBelowPOint.dx, bottomLeftCornerBelowPOint.dy)
      ..lineTo(topRightCornerBelowPoint.dx, topRightCornerBelowPoint.dy)
      ..close();

    final clipPath = Path()
      ..moveTo(topRightCorner.dx, topRightCorner.dy)
      // ..lineTo(bottomRightCorner.dx, bottomRightCorner.dy)
      ..lineTo(bottomLeftCorner.dx, bottomLeftCorner.dy)
      ..lineTo(bottomLeftCornerBelowPOint.dx, bottomLeftCornerBelowPOint.dy)
      ..lineTo(topRightCornerBelowPoint.dx, topRightCornerBelowPoint.dy)
      ..close();

    canvas.clipPath(clipPath);

    canvas.save();
    canvas.translate(topRightCorner.dx, topRightCorner.dy);

    for (int i = 0; i < 6; i++) {
      final upperShadowPointPaint = Paint()
        ..shader = RadialGradient(
          radius: 0.4,
          colors: [
            Colors.black26,
            Colors.black45.withOpacity(0),
          ],
        ).createShader(
          Rect.fromCircle(center: Offset.zero + Offset(0, 90.0 * i), radius: 150),
        )
        ..imageFilter = ImageFilter.blur(sigmaX: 30, sigmaY: 30);

      canvas.drawCircle(Offset.zero + Offset(0, 90.0 * i), 150, upperShadowPointPaint);
    }

    canvas.restore();
    canvas.save();
    canvas.translate(bottomLeftCorner.dx, bottomLeftCorner.dy);

    for (int i = 0; i < 5; i++) {
      final upperShadowPointPaint = Paint()
        ..shader = RadialGradient(
          radius: 0.4,
          colors: [
            Colors.black26,
            Colors.black45.withOpacity(0),
          ],
        ).createShader(
          Rect.fromCircle(center: Offset.zero + Offset(45.0 * i, -20), radius: 70),
        )
        ..imageFilter = ImageFilter.blur(sigmaX: 30, sigmaY: 30);

      canvas.drawCircle(Offset.zero + Offset(45.0 * i, -20), 70, upperShadowPointPaint);
    }

    canvas.restore();
  }

  double hypot(double side1, double side2) {
    double hypotenuse = sqrt(side1 * side1 + side2 * side2);
    return hypotenuse;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
