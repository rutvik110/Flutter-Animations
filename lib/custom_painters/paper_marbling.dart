import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'dart:math' as math;

class PaperMarblingView extends StatefulWidget {
  const PaperMarblingView({super.key});

  @override
  State<PaperMarblingView> createState() => _PaperMarblingViewState();
}

class _PaperMarblingViewState extends State<PaperMarblingView>
    with SingleTickerProviderStateMixin {
  List<Drop> drops = [];

  late final Ticker ticker;

  @override
  void initState() {
    super.initState();

    ticker = createTicker((elapsed) {
      final position = Vector2(
        math.Random().nextDouble() * 400,
        math.Random().nextDouble() * 400,
      );
      final radius = math.max<double>(math.Random().nextDouble() * 100, 10);
      addInk(position, radius);

      if (isMousePressed) {
        setState(() {
          tineLine(mousePosition.dx, 1, 10);
        });
      }
    });

    // for (var i = 0; i < 10; i++) {
    //   addInk(Vector2(300, 300), 50);
    // }

    // tineLine(300, 20, 10);
    ticker.start();
  }

  void addInk(Vector2 position, double radius) {
    final drop = Drop(
      position: Vector2(position.x, position.y),
      radius: radius,
    );

    // transform other drops
    for (var other in drops) {
      other.marble(drop);
    }

    drops.add(drop);

    setState(() {});

    print("Drop added");
  }

  void tineLine(double xl, double z, double c) {
    for (var i = 0; i < drops.length; i++) {
      final drop = drops[i];
      drop.tine(xl, z, c);
    }
  }

  bool isMousePressed = false;
  Offset mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (event) {
          isMousePressed = true;

          final position = event.globalPosition;
          mousePosition = position;

          // final drop =
          //     Drop(position: Vector2(position.dx, position.dy), radius: 30);

          // // transform other drops
          // for (var other in drops) {
          //   other.marble(drop);
          // }

          // drops.add(drop);

          setState(() {});

          // print("Drop added");
        },
        onTapUp: (event) {
          isMousePressed = false;

          setState(() {});
        },
        child: CustomPaint(
          size: const Size(600, 600),
          painter: PaperMarblingPainter(
            drops: drops,
          ),
        ),
      ),
    );
  }
}

class PaperMarblingPainter extends CustomPainter {
  PaperMarblingPainter({
    required this.drops,
  });

  final List<Drop> drops;

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in drops) {
      drop.show(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

const circleDetail = 100;

class Drop {
  final Vector2 position;
  final double radius;
  final List<Vector2> _vertices = [];

  Drop({
    required this.position,
    required this.radius,
  }) {
    for (var i = 0; i < circleDetail; i++) {
      final angle = lerpDouble(0, 2 * math.pi, i / circleDetail)!;
      Vector2 vector = Vector2(math.cos(angle), math.sin(angle));
      vector = vector * radius;
      vector.add(position);

      _vertices.add(vector);
    }
  }

  double get x => position.x;
  double get y => position.y;

  final paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  void show(Canvas canvas) {
    paint.color = Color.fromRGBO(math.Random().nextInt(255),
        math.Random().nextInt(255), math.Random().nextInt(255), 1);

    final path = Path();

    for (var i = 0; i < _vertices.length; i++) {
      final vertex = _vertices[i];

      if (i == 0) {
        path.moveTo(vertex.x, vertex.y);
        continue;
      }

      path.lineTo(vertex.x, vertex.y);
    }

    canvas.drawPath(
      path,
      paint,
    );
  }

  void marble(Drop other) {
    for (var i = 0; i < _vertices.length; i++) {
      final v = _vertices[i];
      final c = other.position;
      final r = other.radius;
      Vector2 p = v.clone();
      p.sub(c);
      final m = p.length;
      final root = math.sqrt(1 + (r * r) / (m * m));
      p = p * root;
      p.add(c);

      _vertices[i] = p;
    }
  }

  void tine(double xl, double z, double c) {
    final u = 1 / (math.pow(2, 1 / c));
    for (var i = 0; i < _vertices.length; i++) {
      final v = _vertices[i];

      v.x = v.x;
      v.y = v.y + z * math.pow(u, (v.x - xl).abs());
    }
  }
}
