import 'dart:ui';

import 'package:flutter/material.dart';

class BlobsView extends StatefulWidget {
  const BlobsView({super.key});

  @override
  State<BlobsView> createState() => _BlobsViewState();
}

class _BlobsViewState extends State<BlobsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (event) {
          setState(() {
            _pointer = event.localPosition;
          });
        },
        child: Center(
          child: CustomPaint(
            painter: _BlobsPainter(),
            size: MediaQuery.of(context).size,
          ),
        ),
      ),
    );
  }
}

Offset _pointer = const Offset(0, 0);

class _BlobsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blackCirclesPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final blurLayerPaint = Paint()
      ..color = const Color(0xff808080)
      ..style = PaintingStyle.fill
      ..imageFilter = ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
        tileMode: TileMode.decal,
      );

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), blurLayerPaint);

    canvas.drawCircle(_pointer, 70, blackCirclesPainter);
    canvas.drawCircle(Offset(size.width / 2 + 50, size.height / 2), 60, blackCirclesPainter);

    canvas.restore();

    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
      Paint()
        ..color = const Color(0xff808080)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.colorDodge,
    );

    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.colorBurn,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
