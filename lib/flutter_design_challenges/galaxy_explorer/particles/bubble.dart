import 'dart:math';

import 'package:flutter/material.dart';

class Bubble {
  Bubble({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.angle,
    required this.color,
  });

  Offset position;
  Offset velocity;
  double radius;
  double angle;
  Color color;

  void tick(Duration dt, Size canvasSize) {
    final dtInSeconds = dt.inMilliseconds / 1000;

    // position = Offset(
    //   position.dx + cos(angle) * radius,
    //   position.dy + sin(angle) * radius,
    // );

    // map radius to position
    final currentPosition = sqrt(
      pow(position.dx.abs(), 2) + pow(position.dy.abs(), 2),
    );
    final finalPosition =
        ((canvasSize.width / 2) / position.dx.abs()) * currentPosition;
    // calculate the point at which this bubble hits the edge with the current angle
    final ratio = currentPosition / finalPosition;
    bool flicker = Random().nextBool();
    radius = ratio * (flicker ? 1 : 2);
    position += velocity * dtInSeconds;
    color = Color.lerp(Colors.white, Colors.blue, ratio)!;
  }
}
