import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/galaxy_explorer/particles/bubble.dart';

class BubbleSystem extends ChangeNotifier {
  BubbleSystem({
    this.minRadius = 0,
    this.maxRadius = 1,
  }) : _count = 100;

  int _count;
  final double minRadius;
  final double maxRadius;
  final List<Bubble> bubbles = <Bubble>[];

  bool _isInitialized = false;

  late Size _canvasSize;

  double _velocity = 100;

  void updateVelocity(double velocity) => _velocity = velocity;
  void updateCount(double count) => _count = count.toInt();

  void initWorld() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    for (var i = 0; i < _count; i++) {
      bubbles.add(
        _generateParticles(
          _canvasSize,
          _velocity,
        ),
      );
    }
  }

  Bubble _generateParticles(Size canvasSize, double velocity) {
    final random = Random();
    final angle = lerpDouble(0, pi * 2, random.nextDouble())!;
    final position = Offset(cos(angle) * 20, sin(angle) * 20);

    return Bubble(
      position: position,
      angle: angle,
      color: Colors.white,
      velocity: Offset(
        cos(angle) *
            lerpDouble(
              0,
              velocity,
              random.nextDouble(),
            )!,
        sin(angle) *
            lerpDouble(
              0,
              velocity,
              random.nextDouble(),
            )!,
      ),
      radius: lerpDouble(
        minRadius,
        maxRadius,
        random.nextDouble(),
      )!,
    );
  }

  void update(Duration dt) {
    if (!_isInitialized) {
      return;
    }
    // update particles

    //remove particles out of bounds
    removeDeadParticles();

    //add new particles
    addNewParticles();

    for (var i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];

      bubble.tick(dt, _canvasSize);
    }

    notifyListeners();
  }

  void addNewParticles() {
    final toadd = _count - bubbles.length;
    for (var i = 0; i < toadd; i++) {
      bubbles.add(
        _generateParticles(
          _canvasSize,
          _velocity,
        ),
      );
    }
  }

  void removeDeadParticles() {
    for (var i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];
      final isxDead = bubble.position.dx.abs() > _canvasSize.width;
      final isyDead = bubble.position.dy.abs() > _canvasSize.height;
      if (isxDead || isyDead) {
        bubbles.removeAt(i);
      }
    }
  }

  void setCanvasSize(Size canvasSize) => _canvasSize = canvasSize;
}
