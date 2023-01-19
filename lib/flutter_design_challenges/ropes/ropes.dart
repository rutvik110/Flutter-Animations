import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:dart_numerics/dart_numerics.dart' as numerics;
import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

const EPSILON = 1e-6;

class RopesView extends StatefulWidget {
  const RopesView({Key? key}) : super(key: key);

  @override
  State<RopesView> createState() => _RopesViewState();
}

class _RopesViewState extends State<RopesView> {
  Offset dragPoint = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: ((details) {
          dragPoint = details.localPosition;
          dev.log(dragPoint.dx.toString());
          setState(() {});
        }),
        child: CustomPaint(
          painter: RopesPainter(
            dragPoint,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class RopesPainter extends CustomPainter {
  RopesPainter(this.endPoint);

  final Offset endPoint;
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const startingPoint = math.Point(0.1, 0.5);
    final finalendPoint =
        math.Point(endPoint.dx / size.width, endPoint.dy / size.height);
    final curvePoints = getCaternaryCurve(startingPoint, finalendPoint, 1);
    final points = curvePoints
        .map((e) => Offset(e.x * size.width, (e.y) * size.height))
        .toList();
    final path = Path();

    path.moveTo(points.first.dx, points.first.dy);

    for (var point in points) {
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);
  }

  List<math.Point> getCaternaryCurve(
      math.Point point1, math.Point point2, int chainLength) {
    const segments = 25;
    const iterationLimit = 6;
    // The curves are reversed
    final isFlipped = point1.x > point2.x;

    final p1 = isFlipped ? point2 : point1;
    final p2 = isFlipped ? point1 : point2;

    final h = p2.x - p1.x;
    final v = p2.y - p1.y;

    final a = -getCatenaryParameter(
        h.toDouble(), v.toDouble(), chainLength, iterationLimit);
    final x = (a * math.log((chainLength + v) / (chainLength - v)) - h) * 0.5;
    final y = a * cosh(x / a);

    final offsetX = p1.x - x;
    final offsetY = p1.y - y;
    final curveData = getCurve(
      a,
      p1,
      p2,
      offsetX,
      offsetY,
      segments,
    );
    return curveData;
  }

  List<math.Point> getCurve(
    // The catenary parameter.
    double a,
    // First point.
    math.Point p1,
    // Second point.
    math.Point p2,
    double offsetX,
    double offsetY,
    // How many "parts" the chain should be made of.
    int segments,
  ) {
    final data = [
      // Calculate the first point on the curve
      math.Point(p1.x, a * cosh((p1.x - offsetX) / a) + offsetY),
    ];

    final d = p2.x - p1.x;
    final length = segments - 1;

    // Calculate the points in between the first and last point
    for (var i = 0; i < length; i++) {
      final x = p1.x + (d * (i + 0.5)) / length;
      final y = a * cosh((x - offsetX) / a) + offsetY;
      data.add(math.Point(x, y));
    }

    // Calculate the last point on the curve
    data.add(math.Point(p2.x, a * cosh((p2.x - offsetX) / a) + offsetY));

    return data;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double getDistanceBetweenPoints(math.Point p1, math.Point p2) {
  final diff = getDifferenceTo(p1, p2);

  return math.sqrt(math.pow(diff.x, 2) + math.pow(diff.y, 2));
}

math.Point getDifferenceTo(math.Point p1, math.Point p2) {
  return math.Point(p1.x - p2.x, p1.y - p2.y);
}

double getCatenaryParameter(
  double h,
  double v,
  int length,
  int limit,
) {
  final m = math.sqrt(length * length - v * v) / h;
  double x = numerics.acosh(m) + 1;
  double prevx = -1;
  double count = 0;

  // Iterate until we find a suitable catenary parameter or reach the iteration
  // limit
  while ((x - prevx).abs() > EPSILON && count < limit) {
    prevx = x;
    x = x - (sinh(x) - m * x) / (cosh(x) - m);
    count++;
  }

  return h / (2 * x);
}
