import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../main.dart';

class WaveFunctionCollapseView extends StatefulWidget {
  const WaveFunctionCollapseView({super.key});

  @override
  State<WaveFunctionCollapseView> createState() => _WaveFunctionCollapseViewState();
}

class _WaveFunctionCollapseViewState extends State<WaveFunctionCollapseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: WaveFunctionCollapsePainter(),
      ),
    );
  }
}

class WaveFunctionCollapsePainter extends CustomPainter {
  List<Cell> grid = [];

  final int DIM = 2;
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final cellWidth = width / DIM;
    final cellHeight = height / DIM;

    for (var i = 0; i < DIM * DIM; i++) {
      grid.add(
        Cell(
          isCollapsed: false,
          options: [
            Direction.BLANK,
            Direction.UP,
            Direction.RIGHT,
            Direction.DOWN,
            Direction.LEFT,
          ],
        ),
      );
    }

    drawImage(canvas, cellWidth, cellHeight);
  }

  Future<void> drawImage(Canvas canvas, double cellWidth, double cellHeight) async {
    for (var j = 0; j < DIM; j++) {
      for (var i = 0; i < DIM; i++) {
        final index = grid[i + j * DIM];

        canvas.drawImage(tilesImages[index.options[0].tileIndex], Offset(i * cellWidth, j * cellHeight),
            Paint()..color = Colors.red);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Cell {
  final bool isCollapsed;
  final List<Direction> options;

  Cell({
    required this.isCollapsed,
    required this.options,
  });
}

enum Direction {
  BLANK,
  UP,
  RIGHT,
  DOWN,
  LEFT;

  int get tileIndex {
    switch (this) {
      case BLANK:
        return 0;
      case UP:
        return 1;
      case RIGHT:
        return 2;
      case DOWN:
        return 3;
      case LEFT:
        return 4;
    }
  }
}
