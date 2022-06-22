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
  late double baseTranslationY;
  late double verticlItemsPadding;

  double getScaledSize(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseItemHeight,
      maxValue: 70,
      nonHoveredMaxValue: 50,
    );
  }

  double getTranslationY(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseTranslationY,
      maxValue: -22,
      nonHoveredMaxValue: -14,
    );
  }

  double getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaxValue,
  }) {
    late final double propertyValue;

    // 1.
    if (hoveredIndex == null) {
      return baseValue;
    }

    // 2.
    final difference = (hoveredIndex! - index).abs();

    // 3.
    final itemsAffected = items.length;

    // 4.
    if (difference == 0) {
      propertyValue = maxValue;

      // 5.
    } else if (difference <= itemsAffected) {
      final ratio = (itemsAffected - difference) / itemsAffected;

      propertyValue = lerpDouble(baseValue, nonHoveredMaxValue, ratio)!;

      // 6.
    } else {
      propertyValue = baseValue;
    }

    return propertyValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hoveredIndex = null;
    baseItemHeight = 40;

    verticlItemsPadding = 10;
    baseTranslationY = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                height: baseItemHeight,
                left: 0,
                right: 0,
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
              Padding(
                padding: EdgeInsets.all(verticlItemsPadding),
// 1.
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    items.length,
                    (index) {
                      // 2.
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
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
                        // 3.
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

                          alignment: AlignmentDirectional.bottomCenter,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          // 4.
                          child: FittedBox(
                            fit: BoxFit.contain,
                            // 5.
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
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ));
  }
}

List<String> items = [
  '🌟',
  '😍',
  '💙',
  '👋',
  '🙀',
];
