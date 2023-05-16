import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MagicGridView extends StatefulWidget {
  const MagicGridView({super.key});

  @override
  State<MagicGridView> createState() => _MagicGridViewState();
}

class _MagicGridViewState extends State<MagicGridView>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late int activeIndex;
  int? hoveringIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeIndex = 0;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    )
        .chain(CurveTween(
          curve: Curves.easeInOut,
        ))
        .animate(controller);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFF141514),
        child: ListView(
          children: [
            MagicGrid(
              activeIndex: activeIndex,
              animation: animation,
              children: List.generate(
                14,
                (index) => MouseRegion(
                  onEnter: (event) {
                    hoveringIndex = index;
                    setState(() {});
                  },
                  onExit: (event) {
                    hoveringIndex = null;
                    setState(() {});
                  },
                  child: InkWell(
                    onTap: () {
                      activeIndex = index;
                      setState(() {});
                      if (controller.isCompleted) {
                        controller.reverse();
                      } else {
                        controller.forward();
                      }
                    },
                    child: Container(
                      // duration: const Duration(milliseconds: 300),
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.all(8.0),
                      width: 140 + 140 * animation.value,

                      decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                      foregroundDecoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: AnimatedScale(
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 300),
                          scale: hoveringIndex == index ? 1.3 : 1,
                          child: Image.asset(
                            "assets/images/people/${index + 1}.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MagicGrid extends MultiChildRenderObjectWidget {
  MagicGrid({
    super.key,
    required super.children,
    required this.animation,
    required this.activeIndex,
  });
  final Animation<double> animation;
  final int activeIndex;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return MagicGridRenderObject(
      animation: animation,
      activeIndex: activeIndex,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MagicGridRenderObject renderObject) {
    renderObject.activeIndex = activeIndex;
  }
}

class MagicGridParentData extends ContainerBoxParentData<RenderBox> {
  MagicGridParentData({
    this.itemsBefore = 0,
  });
  final int itemsBefore;
}

class MagicGridRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MagicGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MagicGridParentData> {
  MagicGridRenderObject({
    required this.animation,
    required int activeIndex,
  }) : _activeIndex = activeIndex;
  // ignore: prefer_final_fields
  final Animation<double> animation;
  Map<String, Offset> itemsGridPositions = {};
  int _activeIndex;
  int get activeIndex => _activeIndex;

  set activeIndex(int value) {
    if (value != activeIndex) {
      _activeIndex = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    Size size = _performLayout(constraints, false);
    RenderBox? child = firstChild;
    // positioning childs
    child = firstChild;
    Offset childGridOffset = const Offset(0, 0);
    Offset childOffset = const Offset(0, 0);
    Offset listChildOffset = Offset(size.width / 2 - child!.size.width / 2, 0);
    Offset gridChildOffset = const Offset(0, 0);

    while (child != null) {
      double activeChildOffset =
          child.size.height * activeIndex - child.size.height / 2;

      final MagicGridParentData childParentData =
          child.parentData! as MagicGridParentData;

      childGridOffset = childParentData.offset;

      if (animation.value == 0) {
        if (itemsGridPositions[child.hashCode] == null) {
          itemsGridPositions[child.hashCode.toString()] =
              childParentData.offset;
        }
        childOffset = Offset(
          lerpDouble(gridChildOffset.dx, listChildOffset.dx, animation.value)!,
          lerpDouble(gridChildOffset.dy, listChildOffset.dy, animation.value)!,
        );
        childParentData.offset = Offset(
          childOffset.dx,
          childOffset.dy,
        );

        listChildOffset += Offset(
          0,
          child.size.height,
        );
        listChildOffset = Offset(
          size.width / 2 - child.size.width / 2,
          listChildOffset.dy,
        );
        final randomDX = childParentData.itemsBefore * child.size.width;
        gridChildOffset += Offset(
          child.size.width + randomDX * (1 - 0),
          0,
        );
        final childDx = gridChildOffset.dx + child.size.width;
        if (childDx > size.width) {
          gridChildOffset = Offset(
            randomDX,
            gridChildOffset.dy + child.size.height,
          );
        }
      }
      if (animation.value > 0 && animation.value <= 1.0) {
        log(itemsGridPositions.entries.toString());
        final itemGridPosition = itemsGridPositions[child.hashCode.toString()];
        childOffset = Offset(
          lerpDouble(
              itemGridPosition!.dx, listChildOffset.dx, animation.value)!,
          lerpDouble(itemGridPosition.dy, listChildOffset.dy, animation.value)!,
        );
        listChildOffset += Offset(
          0,
          child.size.height,
        );
        listChildOffset = Offset(
          size.width / 2 - child.size.width / 2,
          listChildOffset.dy,
        );
        childParentData.offset = Offset(
          childOffset.dx,
          childOffset.dy - activeChildOffset * animation.value,
        );
      }

      child = childParentData.nextSibling;
    }
  }

  Size _performLayout(BoxConstraints constraints, bool isDry) {
    double height = 0;
    double width = 0;
    double maxHeight = 0;
    double maxWidth = 0;

    RenderBox? child = firstChild;

    // For calculating flex height in column
    //double flexHeight = (constraints.maxHeight - height) / totalFlex;

    // calculating layout sizes
    while (child != null) {
      final MagicGridParentData childParentData =
          child.parentData! as MagicGridParentData;
      late final Size childSize;

      if (isDry) {
        child.getDryLayout(
          BoxConstraints(
            // No flex so no flexheight setting
            // minHeight: child.size.height,
            // maxHeight: child.size.height,
            maxWidth: constraints.maxWidth,
          ),
        );

        childSize = child.size;
      } else {
        child.layout(
          BoxConstraints(
            // minHeight: child.size.height,
            maxHeight: constraints.maxHeight, // child.size.height,
            maxWidth: constraints.maxWidth,
          ),
          parentUsesSize: true,
        );
        childSize = child.size;
      }

      maxHeight += childSize.height;
      maxWidth += childSize.width;

      width = math.max(width, childSize.width);

      height = math.max(height, childSize.height);

      child = childParentData.nextSibling;
    }
    height = maxHeight;
    width = maxWidth;
    size = constraints.constrain(Size(width, height));

    return size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // final Canvas canvas = context.canvas;
    // canvas.rotate(math.pi / 10);
    defaultPaint(context, offset);
  }

  @override
  void attach(covariant PipelineOwner owner) {
    // TODO: implement attach
    super.attach(owner);
    animation.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    // TODO: implement detach
    animation.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! MagicGridParentData) {
      final random = math.Random().nextInt(5);
      child.parentData = MagicGridParentData(
        itemsBefore: random,
      );
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // Iterate over the children in reverse order to prioritize the topmost child for hit testing.
    final children = getChildrenAsList();
    for (final child in children.reversed) {
      final childParentData = child.parentData as MagicGridParentData?;
      if (childParentData != null &&
          child.hitTest(result, position: position - childParentData.offset)) {
        return true;
      }
    }
    return false;
  }
}
