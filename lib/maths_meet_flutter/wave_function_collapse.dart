import 'dart:math';

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

    for (var j = 0; j < DIM; j++) {
      for (var i = 0; i < DIM; i++) {
        grid.add(
          Cell(
            x: i,
            y: j,
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
    }

    grid[2] = Cell(
      x: grid[2].x,
      y: grid[2].y,
      isCollapsed: false,
      options: [
        Direction.UP,
        Direction.DOWN,
      ],
    );
    grid[0] = Cell(
      x: grid[0].x,
      y: grid[0].y,
      isCollapsed: false,
      options: [
        Direction.RIGHT,
        Direction.LEFT,
      ],
    );

    // draw image, reduce the entropy of cells
    List<Cell> gridCopy = List<Cell>.from(grid);
    // sort based on options left
    gridCopy.sort((a, b) => a.options.length.compareTo(b.options.length));

    // filter the items with least entropy
    final int leastCellEntropy = gridCopy[0].options.length;

    int stopIndex = 0;

    for (var i = 0; i < gridCopy.length; i++) {
      if (gridCopy[i].options.length > leastCellEntropy) {
        stopIndex = i;
        break;
      }
    }

    gridCopy = gridCopy.sublist(0, stopIndex);

    final Cell randomCell = gridCopy[Random().nextInt(gridCopy.length)];
    randomCell.isCollapsed = true;
    randomCell.options = [randomCell.options[Random().nextInt(randomCell.options.length)]];

    // update the original grid
    final randomCellIndex = grid.indexOf(randomCell);

    grid[randomCellIndex] = randomCell;

    print(grid);
    print(gridCopy);

    for (var j = 0; j < DIM; j++) {
      for (var i = 0; i < DIM; i++) {
        final cell = grid[i + j * DIM];
        final index = cell.options[0].tileIndex;

        if (cell.isCollapsed) {
          canvas.drawRect(
            Rect.fromLTWH(i * cellWidth, j * cellHeight, cellWidth, cellHeight),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
          );
          canvas.drawImageRect(
            tilesImages[index],
            Rect.fromLTWH(0, 0, tilesImages[index].width.toDouble(), tilesImages[index].height.toDouble()),
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
  bool isCollapsed;
  List<Direction> options;
  final int x;
  final int y;

  Cell({
    required this.isCollapsed,
    required this.options,
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
