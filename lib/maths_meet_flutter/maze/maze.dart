import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

List<Cell> grid = [];
const int DIM = 10;
late Cell current;

class MazeView extends StatefulWidget {
  const MazeView({super.key});

  @override
  State<MazeView> createState() => _MazeViewState();
}

class _MazeViewState extends State<MazeView> with SingleTickerProviderStateMixin {
  late final Ticker ticker;

  @override
  void initState() {
    super.initState();

    for (int j = 0; j < DIM; j++) {
      for (int i = 0; i < DIM; i++) {
        grid.add(
          Cell(
            x: i,
            y: j,
          ),
        );
      }
    }

    current = grid[0];
    current.isVisited = true;
    grid[0] = current;

    ticker = createTicker((elapsed) {
      setState(() {});
    })
      ..start();
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

  final painter = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final cellW = width / DIM;

    for (var i = 0; i < grid.length; i++) {
      final cell = grid[i];
      showCell(canvas, cell, cellW);
    }

    final next = checkNeighbours(current);
    if (next != null) {
      next.isVisited = true;
      grid[index(current.x, current.y)] = current;

      current = next;
    }
  }

  void showCell(Canvas canvas, Cell cell, double cellW) {
    final x = cell.x * cellW;
    final y = cell.y * cellW;

    if (cell.walls[0]) {
      canvas.drawLine(Offset(x, y), Offset(x + cellW, y), painter);
    }

    if (cell.walls[1]) {
      canvas.drawLine(Offset(x + cellW, y), Offset(x + cellW, y + cellW), painter);
    }

    if (cell.walls[2]) {
      canvas.drawLine(Offset(x + cellW, y + cellW), Offset(x, y + cellW), painter);
    }

    if (cell.walls[3]) {
      canvas.drawLine(Offset(x, y + cellW), Offset(x, y), painter);
    }

    if (cell.isVisited) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, cellW, cellW),
        Paint()..color = Colors.blue,
      );
    }
  }

  int index(int x, int y) {
    if (x < 0 || y < 0 || x > DIM - 1 || y > DIM - 1) {
      return -1;
    }

    return x + y * DIM;
  }

  Cell? checkNeighbours(Cell cell) {
    final neighbours = <Cell>[];
    final x = cell.x;
    final y = cell.y;

    final topIndex = index(x, y - 1);
    final rightIndex = index(x + 1, y);
    final bottomIndex = index(x, y + 1);
    final leftIndex = index(x - 1, y);

    if (topIndex != -1 && !grid[topIndex].isVisited) {
      neighbours.add(grid[topIndex]);
    }

    if (rightIndex != -1 && !grid[rightIndex].isVisited) {
      neighbours.add(grid[rightIndex]);
    }

    if (bottomIndex != -1 && !grid[bottomIndex].isVisited) {
      neighbours.add(grid[bottomIndex]);
    }

    if (leftIndex != -1 && !grid[leftIndex].isVisited) {
      neighbours.add(grid[leftIndex]);
    }

    return neighbours.isNotEmpty //
        ? neighbours[Random().nextInt(neighbours.length)]
        : null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Cell {
  final int x;
  final int y;
  final List<bool> walls;
  bool isVisited;

  Cell({
    required this.x,
    required this.y,
    this.walls = const [true, true, true, true],
    this.isVisited = false,
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
