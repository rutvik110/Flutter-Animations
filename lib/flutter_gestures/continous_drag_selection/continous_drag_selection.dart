import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class ContinousDragGesturesDetection extends StatefulWidget {
  const ContinousDragGesturesDetection({super.key});

  @override
  State<ContinousDragGesturesDetection> createState() => _ContinousDragGesturesDetectionState();
}

class _ContinousDragGesturesDetectionState extends State<ContinousDragGesturesDetection> {
  final GlobalKey _parentKey = GlobalKey();

  _detectTapedItem(PointerEvent event) {
    dragPoint = event.localPosition;

    hitTestItems(event);
  }

  void hitTestItems(PointerEvent event) {
    final RenderBox box = _parentKey.currentContext!.findRenderObject() as RenderBox;

    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);

    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;

        if (target is _RenderBoxItemDraggable) {
          setState(() {
            activeIndex = target.index;
            selectedIndex.add(target.index);
            log(selectedIndex.length.toString());
          });
        }
      }
    }
  }

  int? activeIndex;

  Offset dragPoint = Offset.zero;

  // Calculates distance from center of the item to the drag point
  // and returns it as a value between 0 and 1 to use for various animations/effects
  double calculateDistanceValueFromDragPoint(GlobalKey key) {
    if (key.currentContext == null) {
      return 0;
    }
    if (_parentKey.currentContext == null) {
      return 0;
    }
    final RenderBox parent = _parentKey.currentContext!.findRenderObject() as RenderBox;
    final child = key.currentContext!.findRenderObject() as _RenderBoxItemDraggable;
    final childCenter = child.localToGlobal(Offset.zero) + Offset(child.size.width / 2, child.size.height / 2);
    final childPositionWithingParent = parent.globalToLocal(childCenter);

    final dragPostionWithinParent = dragPoint;

    final childPositionVector = vmath.Vector2(childPositionWithingParent.dx, childPositionWithingParent.dy);
    final dragPositionVector = vmath.Vector2(dragPostionWithinParent.dx, dragPostionWithinParent.dy);
    final childCenterToDragPointCircleRadius = childPositionVector.distanceTo(dragPositionVector);
    final childCoverageArea = child.size.width;
    final valueRatioToCenter = 1 - (childCenterToDragPointCircleRadius / childCoverageArea);
    if (child.index == 4) {
      log(valueRatioToCenter.toString());
    }

    return valueRatioToCenter;
  }

  List<GlobalKey> keys = List.generate(9, (index) => GlobalKey());
  final Set<int> selectedIndex = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF383838),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Selected Index",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          Text(
            activeIndex == null ? "None" : activeIndex.toString(),
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Listener(
            key: _parentKey,
            onPointerMove: _detectTapedItem,
            onPointerDown: _detectTapedItem,
            onPointerUp: _detectTapedItem,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                padding: const EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final isActive = activeIndex == index;
                  final isSelected = selectedIndex.contains(index);
                  final key = keys[index];
                  final value = calculateDistanceValueFromDragPoint(key);
                  return ItemDraggable(
                    index: index,
                    key: key,
                    child: SizedBox(
                      height: 90,
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            foregroundDecoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color.fromARGB(255, 0, 0, 0).withOpacity(value.clamp(0, 1)),
                                ],
                                stops: const [
                                  0,
                                  1.0,
                                ],
                              ),
                              border: Border.all(
                                color: const Color.fromARGB(255, 172, 230, 255),
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  8,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  isActive ? const Color(0xFFD3F2FF) : const Color.fromARGB(255, 64, 186, 239),
                                  const Color.fromARGB(255, 185, 227, 255),
                                ],
                                stops: const [
                                  0,
                                  1,
                                ],
                              ),
                              border: Border.all(
                                color: const Color.fromARGB(255, 172, 230, 255),
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDraggable extends SingleChildRenderObjectWidget {
  const ItemDraggable({
    super.key,
    super.child,
    required this.index,
  });
  final int index;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBoxItemDraggable()..index = index;
  }

  @override
  void updateRenderObject(BuildContext context, _RenderBoxItemDraggable renderObject) {
    renderObject.index = index;
  }
}

class _RenderBoxItemDraggable extends RenderProxyBox {
  late int index;
}
