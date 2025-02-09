import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../main.dart';

List<Cell> grid = [];
const int DIM = 10;

class WaveFunctionCollapseView extends StatefulWidget {
  const WaveFunctionCollapseView({super.key});

  @override
  State<WaveFunctionCollapseView> createState() => _WaveFunctionCollapseViewState();
}

class _WaveFunctionCollapseViewState extends State<WaveFunctionCollapseView> with SingleTickerProviderStateMixin {
  late final Ticker ticker;

  @override
  void initState() {
    super.initState();

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

    ticker = createTicker((elapsed) {
      setState(() {});
    })
      ..start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            grid = [];

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
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: InkWell(
        onTap: () {
          setState(() {});
        },
        child: Center(
          child: CustomPaint(
            size: const Size(300, 300),
            painter: WaveFunctionCollapsePainter(),
          ),
        ),
      ),
    );
  }
}

class WaveFunctionCollapsePainter extends CustomPainter {
  WaveFunctionCollapsePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final cellWidth = width / DIM;
    final cellHeight = height / DIM;

    final isEntireGridnotCollapsed = grid.any((element) => !element.isCollapsed);

    if (isEntireGridnotCollapsed) {
      // draw image, reduce the entropy of cells
      List<Cell> gridCopy = List<Cell>.from(grid);
      gridCopy.removeWhere((Cell element) => element.isCollapsed);

      print("GridLength:${gridCopy.length}");

      if (gridCopy.isEmpty) {
        gridCopy = grid;
      }

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

      if (stopIndex > 0) {
        gridCopy = gridCopy.sublist(0, stopIndex);
      }

      final Cell randomCell = gridCopy[Random().nextInt(gridCopy.length)];
      randomCell.isCollapsed = true;
      if (randomCell.options.isNotEmpty) {
        randomCell.options = [randomCell.options[Random().nextInt(randomCell.options.length)]];
      }

      // update the original grid
      final randomCellIndex = grid.indexOf(randomCell);

      grid[randomCellIndex] = randomCell;
    }

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

    if (isEntireGridnotCollapsed) {
      grid = formNextGrid();
    }
  }

  List<Cell> formNextGrid() {
    // possibilities
    List<Cell> nextGrid = [];

    for (var j = 0; j < DIM; j++) {
      for (var i = 0; i < DIM; i++) {
        final int index = i + (j * DIM);
        final cell = grid[index];

        if (cell.isCollapsed) {
          nextGrid.add(cell);
        } else {
          List<Direction> options = [
            Direction.BLANK,
            Direction.UP,
            Direction.RIGHT,
            Direction.DOWN,
            Direction.LEFT,
          ];

          // look up
          if (j > 0) {
            final upCell = grid[i + (j - 1) * DIM];
            List<Direction> validOptions = [];

            for (var option in upCell.options) {
              final valid = rules[option]![2];
              validOptions.addAll(valid);
            }

            options = checkValid(options, validOptions);
          }

          // look right
          if (i < DIM - 1) {
            final rightCell = grid[i + 1 + (j * DIM)];
            List<Direction> validOptions = [];

            for (var option in rightCell.options) {
              final valid = rules[option]![3]; // if looking right, i wanna know what's valid to left of the cell
              validOptions.addAll(valid);
            }

            options = checkValid(options, validOptions);
          }

          // look down
          if (j < DIM - 1) {
            final downCell = grid[i + (j + 1) * DIM];
            List<Direction> validOptions = [];

            for (var option in downCell.options) {
              final valid = rules[option]![0]; // if looking down, i wanna know what's valid to up of the cell
              validOptions.addAll(valid);
            }

            options = checkValid(options, validOptions);
          }

          // look left
          if (i > 0) {
            final leftCell = grid[i - 1 + (j * DIM)];
            List<Direction> validOptions = [];

            for (var option in leftCell.options) {
              final valid = rules[option]![1]; // if looking left, i wanna know what's valid to right of the cell
              validOptions.addAll(valid);
            }

            options = checkValid(options, validOptions);
          }

          print("1");

          nextGrid.add(Cell(
            x: grid[index].x,
            y: grid[index].y,
            isCollapsed: false,
            options: options,
          ));
        }
      }
    }

    print("NextGrid-->${nextGrid.map((e) => e.options)}");

    return nextGrid;
  }

  List<Direction> checkValid(List<Direction> options, List<Direction> valid) {
    final List<Direction> validOptions = List.from(options);

    for (var option in options) {
      if (!valid.contains(option)) {
        validOptions.remove(option);
      }
    }

    return validOptions;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return grid.any((element) => !element.isCollapsed);
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
