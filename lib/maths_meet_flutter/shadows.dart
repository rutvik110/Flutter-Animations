import 'dart:math';
import 'dart:ui';

import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

double angle = 18 * (pi / 180);

class FlutterShadows extends StatefulWidget {
  const FlutterShadows({super.key});

  @override
  State<FlutterShadows> createState() => _FlutterShadowsState();
}

class _FlutterShadowsState extends State<FlutterShadows> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text((angle / (pi / 180)).toString()),
            SizedBox(
              width: 300,
              child: Slider(
                value: angle,
                max: 360,
                divisions: 360,
                onChanged: (value) {
                  setState(() {
                    angle = value * (pi / 180);
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
                )
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
    final paint = Paint()
      ..shader = LinearGradient(
          tileMode: TileMode.clamp,
          transform: GradientRotation(
            angle,
          ),
          colors: [
            Colors.black12,
            Colors.white.withOpacity(0),
          ],
          stops: const [
            0,
            0.4,
          ]).createShader(
        Offset.zero & size * 2,
      );
    final width = size.width;
    final height = size.height;
    final topRightCorner = Offset(width - rounredRect.trRadiusX / 1.2, 0);
    final bottomRightCorner = Offset(width, height);
    final bottomLeftCorner = Offset(rounredRect.blRadiusX / 1.2, height);
    final topRightCornerBelowPoint = Offset(width * 1.9, 110);
    final bottomLeftCornerBelowPOint = Offset(width * 1.3, height + 110);
    final path = Path()
      ..moveTo(topRightCorner.dx, topRightCorner.dy)
      ..lineTo(bottomRightCorner.dx, bottomRightCorner.dy)
      ..lineTo(bottomLeftCorner.dx, bottomLeftCorner.dy)
      ..lineTo(bottomLeftCornerBelowPOint.dx, bottomLeftCornerBelowPOint.dy)
      ..lineTo(topRightCornerBelowPoint.dx, topRightCornerBelowPoint.dy)
      ..close();
    final clipPath = Path()
      ..moveTo(topRightCorner.dx, topRightCorner.dy)
      ..lineTo(bottomLeftCorner.dx, bottomLeftCorner.dy)
      ..lineTo(bottomLeftCornerBelowPOint.dx, bottomLeftCornerBelowPOint.dy)
      ..lineTo(topRightCornerBelowPoint.dx, topRightCornerBelowPoint.dy)
      ..close();

    canvas.clipPath(clipPath);
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..shader = LinearGradient(
          tileMode: TileMode.clamp,
          transform: GradientRotation(
            angle,
          ),
          colors: [
            Colors.black12,
            Colors.white.withOpacity(0),
          ],
          stops: const [
            0,
            0.4,
          ]).createShader(
        Offset.zero & size * 2,
      );
    canvas.drawPath(path, paint2);

    Path rectPath = Path()..addRRect(rounredRect);
    rectPath = rectPath.shift(
      const Offset(
        10,
        -5,
      ),
    );

    canvas.drawShadow(rectPath, Colors.black54, 18, true);

    final rectRoundedRightSideBorderLine = Path()
      ..moveTo(
        width,
        0,
      )
      //rounded br center
      ..lineTo(
        rounredRect.width,
        rounredRect.height,
      )
      ..lineTo(
        0,
        height,
      );

    final arcRectPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..imageFilter = ImageFilter.blur(
        sigmaX: 0.1,
        sigmaY: 0.1,
      );

    // canvas.drawPath(rectRoundedRightSideBorderLine, arcRectPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
