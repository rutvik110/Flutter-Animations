// An example of simulating a simple rope. For, the construction of rope, catenary algorithm(https://en.wikipedia.org/wiki/Catenary) is used.
// The catenary is a curve that describes the shape of a hanging chain or cable, or the curve described by a freely hanging chain or cable.
// The implementation of catenary algorithm is based on the following js implementation : https://github.com/dulnan/catenary-curve/blob/9cb7e53e2db4bd5c499f5051abde8bfd853d946a/src/main.ts#L254
// Catenary dart algorithm gist : https://gist.github.com/rutvik110/56f4626c95b92b8cf2c95283d4682331

import 'dart:developer';
import 'dart:ui';

import 'package:flame/extensions.dart';
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
  //double springK = 1;
  Vector2 dragVelocity = Vector2.zero();
  Offset ropeStartPoint = Offset.zero;
  Offset ropeEndPoint = Offset.zero;
  Offset dragPoint = Offset.zero;
  Offset endPoint = Offset.zero;
  double elapsedDelta = 0;
  Duration elapsedDuration = Duration.zero;

  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  final station1Key = GlobalKey();

  bool isConnected = false;
  int segmentLength = 35;
  double ropeSegmentLength = 0.01;
  late List<Offset> ropeSegments;
  late List<Offset> oldSegments;

  void addPoints(Size size) {
    Offset startPoint = ropeStartPoint;
    for (var i = 0; i < segmentLength; i++) {
      ropeSegments[i] = startPoint;
      startPoint = Offset(startPoint.dx + ropeSegmentLength, startPoint.dy);
    }
    oldSegments = ropeSegments;
  }

  void simulate(Size size) {
    Vector2 forceGravity = Vector2(0, 1);
    Vector2 wind = Vector2(dragVelocity.x / 100, 0);
    for (var i = 0; i < segmentLength; i++) {
      Offset firstSegment = ropeSegments[i];
      Vector2 velocity = firstSegment.posNow - oldSegments[i].posNow;

      oldSegments[i] = firstSegment;
      Vector2 latestPosition = firstSegment.posNow + velocity;
      // Vector2 extension = Vector2.zero();
      // Vector2 springForce = Vector2.zero();
      // if (i != segmentLength - 1) {
      //   extension = (ropeSegments[i + 1].posNow - ropeSegments[i].posNow);
      //   springForce = Vector2(extension.x * springK, extension.y * springK);
      // } else {
      //   extension = ropeSegments[i].posNow - ropeSegments[i - 1].posNow;
      //   springForce = Vector2(extension.x * springK, extension.y * springK);
      // }
      latestPosition += wind * (1 / 60);
      latestPosition += forceGravity * (1 / 60);
      // latestPosition += springForce;
      // log(springForce.toString());

      firstSegment = Offset(latestPosition.x, latestPosition.y);
      ropeSegments[i] = firstSegment;
    }

    for (var i = 0; i < 50; i++) {
      applyConstraints(size);
    }
  }

  void applyConstraints(Size size) {
    ropeSegments[0] = ropeStartPoint;
    ropeSegments[segmentLength - 1] = ropeEndPoint;

    for (var i = 0; i < segmentLength - 1; i++) {
      Vector2 firstSegment = ropeSegments[i].posNow;
      Vector2 secondSegment = ropeSegments[i + 1].posNow;
      final dist = (firstSegment).distanceTo(secondSegment);
      double error = (dist - ropeSegmentLength).abs();
      Vector2 changeDir = Vector2.zero();
      if (dist > ropeSegmentLength) {
        changeDir = (firstSegment - secondSegment).normalized();
      } else if (dist < ropeSegmentLength) {
        changeDir = (secondSegment - firstSegment).normalized();
      }

      Vector2 changedAmount = changeDir * error;
      if (i != 0) {
        firstSegment -= changedAmount *
            0.5; // multiply by error for proper single point hanging and by 0.5 for bridge;
        ropeSegments[i] = Offset(firstSegment.x, firstSegment.y);
        secondSegment += (changedAmount * 0.5);
        ropeSegments[i + 1] = Offset(secondSegment.x, secondSegment.y);
      } else {
        secondSegment += changedAmount;
        ropeSegments[i + 1] = Offset(secondSegment.x, secondSegment.y);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ropeSegments = List.generate(
      segmentLength,
      (index) => Offset(
        0,
        index.toDouble(),
      ),
    );
    oldSegments = List.generate(segmentLength, (index) => Offset.zero);
    helloWorld = Stripes.compile();
    delta = 0;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    dragPoint = Offset(size.width * 0.5, 200);
    endPoint = const Offset(100, 200);
    ropeStartPoint = Offset(
      dragPoint.dx / size.width,
      dragPoint.dy / size.height,
    );
    ropeEndPoint = Offset(
      endPoint.dx / size.width,
      endPoint.dy / size.height,
    );
    addPoints(size);
    log(ropeSegments.toString());
    ticker = Ticker((value) {
      elapsedDelta = (value - elapsedDuration).inMilliseconds.toDouble();
      log(elapsedDelta.toString());
      elapsedDuration = value;
      setState(() {
        delta += 1 / 60;
        simulate(size);
      });
    })
      ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const topPadding = 100.0;
    final size = MediaQuery.of(context).size;
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
                  dragPoint = details.globalPosition;
                  dragVelocity = details.delta.toVector2();

                  ropeStartPoint = Offset(
                    dragPoint.dx / size.width,
                    dragPoint.dy / size.height,
                  );
                  //addPoints(size);
                }),
                feedback: const SizedBox.shrink(),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    color: Colors.yellowAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: endPoint.dy - 48 / 1.2,
            left: endPoint.dx - 48 / 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Draggable(
                  onDragUpdate: ((details) {
                    endPoint = details.globalPosition;
                    ropeEndPoint = Offset(
                      endPoint.dx / size.width,
                      endPoint.dy / size.height,
                    );

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
                          ropeStartPoint,
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
                          ropeSegments,
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
    this.segments,
  );

  final Offset endPoint;
  final Offset startPoint;
  final Shader stripes;
  List<Offset> segments;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..shader = stripes
      ..style = PaintingStyle.stroke;
    Paint paint2 = Paint()
      ..color = Colors.red
      ..strokeWidth = 5.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    segments = segments
        .map((e) => Offset(e.dx * size.width, e.dy * size.height))
        .toList();
    path.moveTo(
      segments.first.dx,
      segments.first.dy,
    );

    for (var point in segments) {
      path.lineTo(
        point.dx,
        point.dy,
      );
    }

    canvas.drawPath(path, paint);
    canvas.drawPoints(PointMode.points, segments, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension GetVelocity on Offset {
  Vector2 get posNow {
    return Vector2(dx, dy);
  }
}
