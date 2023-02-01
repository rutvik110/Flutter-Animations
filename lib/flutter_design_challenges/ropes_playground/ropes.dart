// An example of simulating a simple rope. For, the construction of rope, catenary algorithm(https://en.wikipedia.org/wiki/Catenary) is used.
// The catenary is a curve that describes the shape of a hanging chain or cable, or the curve described by a freely hanging chain or cable.
// The implementation of catenary algorithm is based on the following js implementation : https://github.com/dulnan/catenary-curve/blob/9cb7e53e2db4bd5c499f5051abde8bfd853d946a/src/main.ts#L254
// Catenary dart algorithm gist : https://gist.github.com/rutvik110/56f4626c95b92b8cf2c95283d4682331

import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:dart_numerics/dart_numerics.dart' as numerics;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes.dart';
import 'package:flutter_animations/util/extensions/colot_to_vector.dart';
import 'package:scidart/numdart.dart';

const EPSILON = 1e-6;

class RopesView extends StatefulWidget {
  const RopesView({Key? key}) : super(key: key);

  @override
  State<RopesView> createState() => _RopesViewState();
}

class _RopesViewState extends State<RopesView> {
  Offset dragPoint = Offset.zero;
  Offset dragPoint2 = Offset.zero;
  Offset dragPoint3 = Offset.zero;

  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  final station1Key = GlobalKey();
  final station2Key = GlobalKey();
  final station3Key = GlobalKey();
  bool isConnected = false;
  bool isConnected2 = false;
  bool isConnected3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = Stripes.compile();
    delta = 0;
    ticker = Ticker((elapsedTime) {
      setState(() {
        delta += 1 / 60;
      });
    })
      ..start();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    dragPoint = Offset(size.width / 2 - 50, 200);
    dragPoint2 = Offset(size.width / 2, 300);
    dragPoint3 = Offset(size.width / 2 + 50, 400);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  bool isConnectedPowere(GlobalKey stationKey, Offset pointer) {
    final renderBox =
        stationKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);
    final size = renderBox.size;
    return pointer.dx > offset.dx &&
        pointer.dy > offset.dy &&
        pointer.dx < offset.dx + size.width &&
        pointer.dy < offset.dy + size.height;
  }

  @override
  Widget build(BuildContext context) {
    const topPadding = 100.0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // DragPoint 1
          Positioned(
            top: dragPoint.dy - 48 / 1.2,
            left: dragPoint.dx - 48 / 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Draggable(
                  onDragUpdate: ((details) {
                    dragPoint = details.localPosition;
                    isConnected = isConnectedPowere(station1Key, dragPoint);
                    setState(() {});
                  }),
                  feedback: const SizedBox.shrink(),
                  child: const Icon(
                    Icons.power,
                    size: 48,
                    color: Colors.yellowAccent,
                  )),
            ),
          ),
          // DragPoint 2
          Positioned(
            top: dragPoint2.dy - 48 / 1.2,
            left: dragPoint2.dx - 48 / 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Draggable(
                onDragUpdate: ((details) {
                  dragPoint2 = details.localPosition;
                  isConnected2 = isConnectedPowere(station2Key, dragPoint2);
                  setState(() {});
                }),
                feedback: const SizedBox.shrink(),
                child: const Icon(
                  Icons.power,
                  size: 48,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
          // DragPoint 3
          Positioned(
            top: dragPoint3.dy - 48 / 1.2,
            left: dragPoint3.dx - 48 / 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Draggable(
                onDragUpdate: ((details) {
                  dragPoint3 = details.localPosition;
                  isConnected3 = isConnectedPowere(station3Key, dragPoint3);
                  dev.log(isConnected3.toString());
                  setState(() {});
                }),
                feedback: const SizedBox.shrink(),
                child: const Icon(
                  Icons.power,
                  size: 48,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          // Cars
          IgnorePointer(
            ignoring: true,
            child: FutureBuilder<Stripes>(
              future: helloWorld,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      CustomPaint(
                        painter: RopesPainter(
                          const Offset(50, 100 + topPadding),
                          dragPoint,
                          snapshot.data!.shader(
                            resolution: MediaQuery.of(context).size,
                            uTime: delta,
                            tiles: 20.0,
                            speed: !isConnected ? 0 : delta / 10,
                            direction: 0.5, // -1 to 1
                            warpScale: 0,
                            warpTiling: 0,
                            color1: isConnected
                                ? Colors.yellow.toColorVector()
                                : Colors.grey.toColorVector(),
                            color2: isConnected
                                ? Colors.amber.toColorVector()
                                : Colors.blueGrey.toColorVector(),
                          ),
                        ),
                        size: Size.infinite,
                      ),
                      CustomPaint(
                        painter: RopesPainter(
                          const Offset(50, 250 + topPadding),
                          dragPoint2,
                          snapshot.data!.shader(
                            resolution: MediaQuery.of(context).size,
                            uTime: delta,
                            tiles: 20.0,
                            speed: !isConnected2 ? 0 : delta / 10,
                            direction: 0.5, // -1 to 1
                            warpScale: 0,
                            warpTiling: 0,
                            color1: isConnected2
                                ? Colors.greenAccent.toColorVector()
                                : Colors.grey.toColorVector(),
                            color2: isConnected2
                                ? Colors.green.toColorVector()
                                : Colors.blueGrey.toColorVector(),
                          ),
                        ),
                        size: Size.infinite,
                      ),
                      CustomPaint(
                        painter: RopesPainter(
                          const Offset(50, 400 + topPadding),
                          dragPoint3,
                          snapshot.data!.shader(
                            resolution: MediaQuery.of(context).size,
                            uTime: delta,
                            tiles: 20.0,
                            speed: !isConnected3 ? 0 : delta / 10,
                            direction: 0.5, // -1 to 1
                            warpScale: 0,
                            warpTiling: 0,
                            color1: isConnected3
                                ? Colors.redAccent.toColorVector()
                                : Colors.grey.toColorVector(),
                            color2: isConnected3
                                ? Colors.red.toColorVector()
                                : Colors.blueGrey.toColorVector(),
                          ),
                        ),
                        size: Size.infinite,
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          // Changing Stations
          IgnorePointer(
            ignoring: true,
            child: Padding(
              padding: const EdgeInsets.only(top: topPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.charging_station_outlined,
                          size: 48,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.charging_station_outlined,
                          size: 48,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.charging_station_outlined,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        key: station1Key,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.drive_eta_rounded,
                          size: 48,
                          color: isConnected ? Colors.amber : Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        key: station2Key,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.drive_eta_rounded,
                          size: 48,
                          color:
                              isConnected2 ? Colors.greenAccent : Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        key: station3Key,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 40, 40, 40),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.drive_eta_rounded,
                          size: 48,
                          color: isConnected3 ? Colors.redAccent : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RopesPainter extends CustomPainter {
  RopesPainter(
    this.startPoint,
    this.endPoint,
    this.stripes,
  );

  final Offset endPoint;
  final Offset startPoint;
  final Shader stripes;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..shader = stripes
      ..style = PaintingStyle.stroke;

    final startingPoint =
        math.Point(startPoint.dx / size.width, startPoint.dy / size.height);
    final finalendPoint =
        math.Point(endPoint.dx / size.width, endPoint.dy / size.height);

    final curvePoints = getCaternaryCurve(startingPoint, finalendPoint, 0.7);
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
      math.Point point1, math.Point point2, double chainLength) {
    const segments = 40;
    const iterationLimit = 11;
    // The curves are reversed
    final isFlipped = point1.x > point2.x;

    final p1 = isFlipped ? point2 : point1;
    final p2 = isFlipped ? point1 : point2;

    final h = p2.x - p1.x;
    final v = p2.y - p1.y;

    final a = -getCatenaryParameter(h.toDouble(), v.toDouble(), chainLength,
        iterationLimit, point1, point2);
    // Handle NAN/rope being stretched than its original length case
    if (a.isNaN) {
      return [point1, point2];
    }
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
  double length,
  int limit,
  math.Point point,
  math.Point point2,
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
