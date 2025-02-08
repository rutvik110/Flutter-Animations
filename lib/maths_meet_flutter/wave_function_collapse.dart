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
        size: const Size(300, 300),
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
        final cell = grid[i + j * DIM];

        if (cell.isCollapsed) {
          canvas.drawRect(
            Rect.fromLTWH(i * cellWidth, j * cellHeight, cellWidth, cellHeight),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
          );
          canvas.drawImageRect(
            tilesImages[cell.options[1].tileIndex],
            Rect.fromLTWH(0, 0, tilesImages[cell.options[1].tileIndex].width.toDouble(),
                tilesImages[cell.options[1].tileIndex].height.toDouble()),
            Rect.fromLTWH(i * cellWidth, j * cellHeight, cellWidth, cellHeight),
            Paint(),
          );
        } else {
          canvas.drawRect(
            Rect.fromLTWH(i * cellWidth, j * cellHeight, cellWidth, cellHeight),
            Paint()..color = Colors.blue,
          );
        }
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
