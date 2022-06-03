import 'dart:ui';

import 'package:flutter/material.dart';

class MacOsInspiredDoc extends StatefulWidget {
  const MacOsInspiredDoc({Key? key}) : super(key: key);

  @override
  State<MacOsInspiredDoc> createState() => _MacOsInspiredDocState();
}

class _MacOsInspiredDocState extends State<MacOsInspiredDoc> {
  late int? hoveredIndex;

  double getScaledSize(int index) {
    if (hoveredIndex == null) {
      return 40;
    }

    late final double hoveredSize;
    final difference = (hoveredIndex! - index).abs();
    if (difference == 0) {
      hoveredSize = 70;
    } else if (difference <= 5) {
      final scaleRatio = (5 - difference) / 5;

      hoveredSize = lerpDouble(40, 50, scaleRatio)!;
    } else {
      hoveredSize = 40;
    }

    return hoveredSize;
  }

  double getTranslationY(int index) {
    if (hoveredIndex == null) {
      return 0;
    }

    late final double translationY;

    final difference = (hoveredIndex! - index).abs();
    if (difference == 0) {
      translationY = -22;
    } else if (difference <= 5) {
      final scaleRatio = (5 - difference) / 5;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  bottom: 0,
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(115, 100, 100, 100),
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
                IntrinsicWidth(
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: AlignmentDirectional.bottomCenter,
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
              ],
            ),
          ),
        ],
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
