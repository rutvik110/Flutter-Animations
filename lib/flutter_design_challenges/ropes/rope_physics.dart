// An example of simulating a simple rope. For, the construction of rope, catenary algorithm(https://en.wikipedia.org/wiki/Catenary) is used.
// The catenary is a curve that describes the shape of a hanging chain or cable, or the curve described by a freely hanging chain or cable.
// The implementation of catenary algorithm is based on the following js implementation : https://github.com/dulnan/catenary-curve/blob/9cb7e53e2db4bd5c499f5051abde8bfd853d946a/src/main.ts#L254
// Catenary dart algorithm gist : https://gist.github.com/rutvik110/56f4626c95b92b8cf2c95283d4682331

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes.dart';
import 'package:flutter_animations/util/extensions/colot_to_vector.dart';

const EPSILON = 1e-6;

class RopesPhysics extends StatefulWidget {
  const RopesPhysics({Key? key}) : super(key: key);

  @override
  State<RopesPhysics> createState() => _RopesViewState();
}

class _RopesViewState extends State<RopesPhysics> {
  Offset dragPoint = Offset.zero;

  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  final station1Key = GlobalKey();

  bool isConnected = false;

  late List<Offset> originalPoints;
  late List<Offset> updatedPoints;

  void updatePoints(Size size) {
    const NormalLength = 3.0;
    const Gravity = 10.0;

    for (var i = 1; i < 99; i++) {
      double xvector1 = originalPoints[i - 1].dx - originalPoints[i].dx;
      double yvector1 = originalPoints[i - 1].dy - originalPoints[i].dy;
      double Magnitude1 = math.sqrt(math.pow(xvector1, 2) +
          math.pow(yvector1, 2)); //LengthOf (X_Vector1, Y_Vector1)
      double Extension1 = Magnitude1 - NormalLength;

      double XVector2 = originalPoints[i + 1].dx - originalPoints[i].dx;
      double YVector2 = originalPoints[i + 1].dy - originalPoints[i].dy;
      double Magnitude2 = math.sqrt(
        math.pow(XVector2, 2) +
            math.pow(
              YVector2,
              2,
            ),
      ); // LengthOf(X_Vector2, Y_Vector2)
      double Extension2 = Magnitude2 - NormalLength;

      double xv = ((xvector1 / Magnitude1) * Extension1) +
          ((XVector2 / Magnitude2) * Extension2);
      double yv = ((yvector1 / Magnitude1) * Extension1) +
          ((YVector2 / Magnitude2) * Extension2) +
          Gravity;

      updatedPoints[i] = Offset(
          originalPoints[i].dx + (xv * .01), originalPoints[i].dy + (yv * .01));

      //(Note you can use what ever value you like instead of .01)
    }
    originalPoints = updatedPoints;

    //  originalPoints.last = Offset(dragPoint.dx, dragPoint.dy);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    originalPoints = List.generate(
      100,
      (index) => Offset(
        0,
        index.toDouble(),
      ),
    );
    originalPoints.last = dragPoint;
    updatedPoints = List.generate(100, (index) => Offset.zero);
    helloWorld = Stripes.compile();
    delta = 0;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    ticker = Ticker((elapsedTime) {
      setState(() {
        delta += 1 / 60;
        updatePoints(size);
      });
    })
      ..start();
    dragPoint = Offset(size.width / 2, 200);
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
                    setState(() {});
                  }),
                  feedback: const SizedBox.shrink(),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      color: Colors.yellowAccent,
                      shape: BoxShape.circle,
                    ),
                  )),
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
                        painter: StringsPainter(
                          Offset(
                            MediaQuery.of(context).size.width / 2,
                            100 + topPadding,
                          ),
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
                          originalPoints,
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
        ],
      ),
    );
  }
}

class StringsPainter extends CustomPainter {
  StringsPainter(
    this.startPoint,
    this.endPoint,
    this.stripes,
    this.originalPoints,
  );

  final Offset endPoint;
  final Offset startPoint;
  final Shader stripes;
  final List<Offset> originalPoints;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    // TODO: implement paint
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..shader = stripes
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(originalPoints.first.dx, originalPoints.first.dy);
    final adjustableList = List<Offset>.from(originalPoints);
    adjustableList.removeLast();
    for (var point in adjustableList) {
      path.lineTo(
        point.dx,
        point.dy,
      );
    }

    canvas.drawPath(path, paint);
    canvas.drawPoints(
        PointMode.points,
        adjustableList,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 10.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
