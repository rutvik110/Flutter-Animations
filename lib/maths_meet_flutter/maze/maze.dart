import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart';

import '../../main.dart';

List<Cell> grid = [];
const int DIM = 10;

class MazeView extends StatefulWidget {
  const MazeView({super.key});

  @override
  State<MazeView> createState() => _MazeViewState();
}

class _MazeViewState extends State<MazeView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    for (int j = 0; j < DIM; j++) {
      for (int i = 0; i < DIM; i++) {
        grid.add(Cell(x: i, y: j));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(500, 500),
          painter: MazePainter(),
        ),
      ),
    );
  }
}

class MazePainter extends CustomPainter {
  MazePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    final width = size.width;
    final height = size.height;
    final cellW = width / DIM;
    final cellH = height / DIM;

    for (var i = 0; i < grid.length; i++) {
      final cell = grid[i];
      final x = cell.x * cellW;
      final y = cell.y * cellH;

      canvas.drawRect(
        Rect.fromLTWH(x, y, cellW, cellH),
        painter,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Cell {
  final int x;
  final int y;

  Cell({
    required this.x,
    required this.y,
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

const rules = {
  Direction.BLANK: [
    [Direction.BLANK, Direction.UP],
    [Direction.BLANK, Direction.RIGHT],
    [Direction.BLANK, Direction.DOWN],
    [Direction.BLANK, Direction.LEFT],
  ],
  Direction.UP: [
    [Direction.RIGHT, Direction.LEFT, Direction.DOWN],
    [Direction.LEFT, Direction.UP, Direction.DOWN],
    [Direction.BLANK, Direction.DOWN],
    [Direction.RIGHT, Direction.UP, Direction.DOWN],
  ],
  Direction.RIGHT: [
    [Direction.RIGHT, Direction.LEFT, Direction.DOWN],
    [Direction.LEFT, Direction.UP, Direction.DOWN],
    [Direction.RIGHT, Direction.LEFT, Direction.UP],
    [Direction.BLANK, Direction.LEFT],
  ],
  Direction.DOWN: [
    [Direction.BLANK, Direction.UP],
    [Direction.LEFT, Direction.UP, Direction.DOWN],
    [Direction.RIGHT, Direction.LEFT, Direction.UP],
    [Direction.RIGHT, Direction.UP, Direction.DOWN],
  ],
  Direction.LEFT: [
    [Direction.RIGHT, Direction.LEFT, Direction.DOWN],
    [Direction.BLANK, Direction.RIGHT],
    [Direction.RIGHT, Direction.LEFT, Direction.UP],
    [Direction.UP, Direction.DOWN, Direction.RIGHT],
  ],
};
