import 'dart:developer' as dev;

import 'package:flutter/material.dart';

class CubiclesWave extends StatefulWidget {
  const CubiclesWave({Key? key}) : super(key: key);

  @override
  State<CubiclesWave> createState() => _CubiclesWaveState();
}

class _CubiclesWaveState extends State<CubiclesWave>
    with SingleTickerProviderStateMixin {
  late Offset offset;

  late final AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat(reverse: true);
    offset = Offset.zero;

    animationController.addListener(() {
      setState(() {});
      dev.log(animationController.value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            offset = details.localPosition;
            // animationController.forward();
            // if (!animationController.isAnimating) {
            //   if (!animationController.isCompleted) {
            //     // animationController.reverse();
            //     animationController.reverse();
            //   }else{
            //       animationController.reverse();

            //   }
            // }
          });
        },
        child: CustomPaint(
          painter: CubiclesWavePainter(
            // offset: offset,
            animationValue: Tween<double>(begin: 0.0, end: 1.0)
                .chain(
                  CurveTween(
                    curve: Curves.slowMiddle,
                  ),
                )
                .animate(animationController)
                .value,
          ),
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}

class CubiclesWavePainter extends CustomPainter {
  final double animationValue;
  CubiclesWavePainter({
    required this.animationValue,
  });
  @override
  void paint(Canvas canvas, Size size) {
    const imaginarySizeOfCubic = 20;
    final horizontalBlocks = size.width ~/ imaginarySizeOfCubic;
    final verticalBlocks = size.height ~/ imaginarySizeOfCubic;
    const maxWaveHeight = 100;
    const baseCubicSize = 10;

    for (var i = 0; i < horizontalBlocks; i++) {
      final itemValue = i / horizontalBlocks;
      const circleDiameter = 0.2;
      final isInRange = itemValue >= animationValue - circleDiameter / 2 &&
          itemValue <= animationValue + circleDiameter / 2;

      final isAhead = itemValue >= animationValue;
      final isBehind = itemValue <= animationValue;

      final blockValueWithinCircle =
          (animationValue + (circleDiameter / 2)) - itemValue;
      final highValue = !isAhead
          ? 1.0 - (blockValueWithinCircle / circleDiameter)
          : !isBehind
              ? blockValueWithinCircle / circleDiameter
              : itemValue == animationValue
                  ? 1.0
                  : 0.0;
      for (var j = 0; j < verticalBlocks; j++) {
        final randomValue = (i) / (horizontalBlocks);
        final paint = Paint()
          ..color = Colors.blue.withGreen(
            (255 * randomValue).toInt(),
          );
        final rect = Rect.fromLTWH(
          i * imaginarySizeOfCubic.toDouble(),
          j * imaginarySizeOfCubic -
              (isInRange ? highValue * maxWaveHeight : 0),
          baseCubicSize * highValue,
          baseCubicSize * highValue,
        );
        canvas.drawRect(
          rect,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// class CubiclesWavePainter extends CustomPainter {
//   CubiclesWavePainter({
//     required this.offset,
//     required this.animationValue,
//   });

//   final Offset offset;
//   final double animationValue;
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.white;
//     final paint2 = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.red;
//     // canvas.translate(size.width / 2, size.height / 2);
//     final horizontalBlocks = size.width ~/ 2;
//     final verticalBlocks = size.height ~/ 2;

//     for (var i = 0; i < horizontalBlocks; i++) {
//       // if (i.isEven) {

//       for (var j = 0; j < verticalBlocks; j++) {
//         double x = i * 24;
//         double y = j * 24;

//         final isInRange =
//             (x - offset.dx).abs() < 100 && (y - offset.dy).abs() < 100;

//         // if (x.toInt().isEven) {
//         if (isInRange) {
//           // decrease or increase x,y values to go to edges of the range square based on whethere their x is
//           // greater than or less than the offset x and y is greater than or less than the offset y
//           // x += (isInRange ? 1 * animationValue : 0);
//           // y += (isInRange ? 1 * animationValue : 0);
//           final shouldMoveToTopLeftCorner = x < offset.dx && y < offset.dy;
//           final shouldMoveToBottomRightCorner = x > offset.dx && y > offset.dy;
//           final shouldMoveToTopRightCorner = x > offset.dx && y < offset.dy;
//           final shouldMoveToBottomLeftCorner = x < offset.dx && y > offset.dy;

//           if (shouldMoveToTopLeftCorner) {
//             // calculate top left corner of the range square
//             final topLeftCorner = Offset(offset.dx - 100, offset.dy - 100);
//             // distance between topleftCorner and x,y
//             final xdistance = (topLeftCorner.dx - x).abs();
//             final ydistance = (topLeftCorner.dy - y).abs();

//             if (xdistance > ydistance) {
//               y -= ydistance * animationValue;
//             } else if (ydistance > xdistance) {
//               x -= xdistance * animationValue;
//             } else {
//               x -= xdistance * animationValue;
//               y -= ydistance * animationValue;
//             }
//           } else if (shouldMoveToBottomRightCorner) {
//             // calculate bottom right corner of the range square
//             final bottomRightCorner = Offset(offset.dx + 100, offset.dy + 100);
//             // distance between bottomRightCorner and x,y
//             final xdistance = (bottomRightCorner.dx - x).abs();
//             final ydistance = (bottomRightCorner.dy - y).abs();
//             if (xdistance > ydistance) {
//               y += ydistance * animationValue;
//             } else if (ydistance > xdistance) {
//               x += xdistance * animationValue;
//             } else {
//               x += xdistance * animationValue;
//               y += ydistance * animationValue;
//             }
//           } else if (shouldMoveToTopRightCorner) {
//             // calculate top right corner of the range square
//             final topRightCorner = Offset(offset.dx + 100, offset.dy - 100);
//             // distance between topRightCorner and x,y
//             final xdistance = (topRightCorner.dx - x).abs();
//             final ydistance = (topRightCorner.dy - y).abs();
//             if (xdistance > ydistance) {
//               y -= ydistance * animationValue;
//             } else if (ydistance > xdistance) {
//               x += xdistance * animationValue;
//             } else {
//               x += xdistance * animationValue;
//               y -= ydistance * animationValue;
//             }
//           } else if (shouldMoveToBottomLeftCorner) {
//             // calculate bottom left corner of the range square
//             final bottomLeftCorner = Offset(offset.dx - 100, offset.dy + 100);
//             // distance between bottomLeftCorner and x,y
//             final xdistance = (bottomLeftCorner.dx - x).abs();
//             final ydistance = (bottomLeftCorner.dy - y).abs();

//             if (xdistance > ydistance) {
//               y += ydistance * animationValue;
//             } else if (ydistance > xdistance) {
//               x -= xdistance * animationValue;
//             } else {
//               x -= xdistance * animationValue;
//               y += ydistance * animationValue;
//             }
//           } else {
//             x += (isInRange ? 1 * animationValue : animationValue * x);
//             y += (isInRange ? 1 * animationValue : animationValue * x);
//           }
//         }
//         final center = Offset(x.toDouble(), y.toDouble());
//         canvas.drawRect(
//           Rect.fromCircle(center: center, radius: 1),
//           paint,
//         );
//         // }
//       }

//       // }
//     }

//     canvas.drawRect(
//       Rect.fromCircle(center: offset, radius: 10),
//       paint2,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
