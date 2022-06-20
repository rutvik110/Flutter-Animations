import 'dart:ui';

import 'package:flutter/material.dart';

class MacOsInspiredDoc extends StatefulWidget {
  const MacOsInspiredDoc({Key? key}) : super(key: key);

  @override
  State<MacOsInspiredDoc> createState() => _MacOsInspiredDocState();
}

class _MacOsInspiredDocState extends State<MacOsInspiredDoc> {
  late int? hoveredIndex;
  late double baseItemHeight;
  late double verticlItemsPadding;

  double getScaledSize(int index) {
    if (hoveredIndex == null) {
      return baseItemHeight;
    }

    late final double hoveredSize;
    final difference = (hoveredIndex! - index).abs();
    // deciedes how many items from the currently hovered index will be affected
    // if changing also adjust hoveredSize accordingly values
    final itemsAffected = items.length;
    if (difference == 0) {
      hoveredSize = 70;
    } else if (difference <= itemsAffected) {
      final scaleRatio = (items.length - difference) / itemsAffected;

      hoveredSize = lerpDouble(baseItemHeight, 50, scaleRatio)!;
    } else {
      hoveredSize = baseItemHeight;
    }

    return hoveredSize;
  }

  double getTranslationY(int index) {
    if (hoveredIndex == null) {
      return 0;
    }

    late final double translationY;

    final difference = (hoveredIndex! - index).abs();
    // deciedes how many items from the currently hovered index will be affected
    // if changing also adjust translation accordingly
    final itemsAffected = items.length;
    if (difference == 0) {
      translationY = -22;
    } else if (difference <= itemsAffected) {
      final scaleRatio = (items.length - difference) / itemsAffected;

      translationY = lerpDouble(0, -14, scaleRatio)!;
    } else {
      translationY = 0;
    }

    return translationY;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hoveredIndex = null;
    baseItemHeight = 40;
    verticlItemsPadding = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        //explain how stack sizes it self
        child: Stack(
          alignment: Alignment.center,
          children: [
            // constraintes passed down by positioned.fill
            Positioned.fill(
              //TODO: explain why we had to use align
              // and what's difference between center and align
              //could referance the positioned widget video on the docs page for Positioned
              child: Align(
                child: SizedBox(
                  height: baseItemHeight,
                  width: double.maxFinite,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(colors: [
                        Colors.blueAccent,
                        Colors.greenAccent,
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(verticlItemsPadding),
              //explain use of intrinsic width and why it's expensive
              // as layout is calculated in advance to know the child size
              // and this not one pass and expensive
              child: IntrinsicWidth(
                child: Row(
                    children: List.generate(items.length, (index) {
                  return MouseRegion(
                    onEnter: ((event) {
                      setState(() {
                        hoveredIndex = index;
                      });
                    }),
                    onExit: (event) {
                      setState(() {
                        hoveredIndex = null;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      transform: Matrix4.identity()
                        ..translate(
                          0.0,
                          getTranslationY(index),
                          0.0,
                        ),
                      height: getScaledSize(index),
                      width: getScaledSize(index),
                      // color: Colors.green,
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      //explain the use of fittedbox
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          style: TextStyle(
                            fontSize: getScaledSize(index),
                          ),
                          child: Text(
                            items[index],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> items = [
  '🌟',
  '😍',
  '💙',
  '👋',
  '🙀',
];


// Center(
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(115, 100, 100, 100),
//             borderRadius: BorderRadius.circular(8),
//             gradient: const LinearGradient(colors: [
//               Colors.blueAccent,
//               Colors.greenAccent,
//             ]),
//           ),
//           child: SizedOverflowBox(
//             size: const Size(350, 50),
//             child: IntrinsicWidth(
//               child: Row(
//                   children: List.generate(items.length, (index) {
//                 return MouseRegion(
//                   onEnter: ((event) {
//                     setState(() {
//                       hoveredIndex = index;
//                     });
//                   }),
//                   onExit: (event) {
//                     setState(() {
//                       hoveredIndex = null;
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(
//                       milliseconds: 300,
//                     ),
//                     transform: Matrix4.identity()
//                       ..translate(
//                         0.0,
//                         getTranslationY(index),
//                         0.0,
//                       ),
//                     height: getScaledSize(index),
//                     width: getScaledSize(index),
//                     // color: Colors.green,
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 5,
//                       vertical: 5,
//                     ),
//                     alignment: AlignmentDirectional.bottomCenter,
//                     child: FittedBox(
//                       fit: BoxFit.contain,
//                       child: AnimatedDefaultTextStyle(
//                         duration: const Duration(
//                           milliseconds: 300,
//                         ),
//                         style: TextStyle(
//                           fontSize: getScaledSize(index),
//                         ),
//                         child: Text(
//                           items[index],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList()),
//             ),
//           ),
//         ),
//       )