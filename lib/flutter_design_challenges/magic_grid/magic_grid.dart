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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Column(
        children: [
          Text(controller.value.toString()),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: Colors.red,
                child: MagicGrid(
                  animation: animation,
                  children: List.generate(
                    10,
                    (index) => Container(
                      height: 50 + 50 * animation.value,
                      margin: const EdgeInsets.all(8.0),
                      width: 50 + 50 * animation.value,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(
                            color: Colors.white,
                          )),
                      child: Center(
                        child: Text(
                          index.toString(),
                          style: TextStyle(
                            fontSize: 20 * animation.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              });
            },
            child: const Text("Change Flex"),
          ),
        ],
      ),
    );
  }
}

class MagicGrid extends MultiChildRenderObjectWidget {
  MagicGrid({
    super.key,
    required super.children,
    required this.animation,
  });
  final Animation<double> animation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return MagicGridRenderObject(
      animation: animation,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MagicGridRenderObject renderObject) {}
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
  });
  // ignore: prefer_final_fields
  final Animation<double> animation;

  // set isColumn(bool value) {
  //   // if (value != isColumn) {
  //   //   isColumn = value;
  //   // // Parent needs to update coze we are changing something on the parent data.
  //   // parentData!.isColumn = value;
  //   if (value != isColumn) {
  //     _isColumn = value;
  //     markNeedsLayout();
  //   }
  //   // }
  // }

  @override
  void performLayout() {
    Size size = _performLayout(constraints, false);
    RenderBox? child = firstChild;
    // positioning childs
    child = firstChild;
    Offset childOffset = const Offset(0, 0);
    Offset listChildOffset = Offset(size.width / 2 - child!.size.width / 2, 0);
    Offset gridChildOffset = const Offset(0, 0);

    while (child != null) {
      final MagicGridParentData childParentData =
          child.parentData! as MagicGridParentData;
      childOffset = Offset(
        lerpDouble(gridChildOffset.dx, listChildOffset.dx, animation.value)!,
        lerpDouble(gridChildOffset.dy, listChildOffset.dy, animation.value)!,
      );
      childParentData.offset = Offset(
        childOffset.dx, //* (animation.value),
        childOffset.dy, //* (1 - animation.value),
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
        child.size.width + randomDX * (1 - 0), //* animation.value,
        0, //* (1 - animation.value),
      );
      final childDx = gridChildOffset.dx + child.size.width;
// need to smooth out its entrance to next row when condition is met
      if (childDx > size.width) {
        final randomDX = childParentData.itemsBefore * child.size.width;
        listChildOffset = Offset(
          size.width / 2 - child.size.width / 2,
          listChildOffset.dy,
        );
        gridChildOffset = Offset(
          randomDX,
          gridChildOffset.dy + child.size.height,
          // lerpDouble(
          //   gridChildOffset.dy,
          //   gridChildOffset.dy + child.size.height,
          //   animation.value,
          // )!,
        );
      }
      // childOffset = Offset(
      //   lerpDouble(gridChildOffset.dx, listChildOffset.dx, animation.value)!,
      //   lerpDouble(gridChildOffset.dy, listChildOffset.dy, animation.value)!,
      // );

      // }

      child = childParentData.nextSibling;
    }
  }

  Size _performLayout(BoxConstraints constraints, bool isDry) {
    double height = 0;
    double width = 0;
    double maxHeight = 0;
    double maxWidth = 0;
    //int totalFlex = 0;

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
      // if (isColumn) {
      //   height += childSize.height;
      width = math.max(width, childSize.width);
      // } else {
      //   width += childSize.width;
      height = math.max(height, childSize.height);
      // }
      child = childParentData.nextSibling;
    }
    height = maxHeight; //lerpDouble(maxHeight, height, animation.value)!;
    width = maxWidth;
    // width = lerpDouble(maxWidth, width, 1.0 - animation.value)!;
    size = constraints.constrain(Size(width, height));
//  size = constraints.constrain(
//       Size(lerpDouble(maxWidth, width, 1.0 - animation.value)!,
//           lerpDouble(maxHeight, height, animation.value)!),
//     );
    // log("${size.height}  ${size.width}");
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
      final random = math.Random().nextInt(4);
      child.parentData = MagicGridParentData(
        itemsBefore: random,
      );
    }
  }
}
