import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animations/flutter_render_objects/custom_expandable.dart';
import 'package:flutter_animations/flutter_render_objects/custom_proxy.dart';
import 'package:flutter_animations/flutter_render_objects/leaf_render_object.dart';

class MyCustomRenderObjectDemo extends StatelessWidget {
  const MyCustomRenderObjectDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Why does container fills up the whole width?
      // When's the need for Baseline? Align uses RenderAlignedShiftedBox that depends on RenderShiftedBox
      // which is used by Baseline.
      body: Stack(
        children: [
          CustomColumn(
            children: [
              CustomBox(
                flex: 1,
              ),
              CustomExpanded(
                child: SizedBox.shrink(),
              ),
              Container(
                color: Colors.red,
                child: SizedBox(
                  height: 100,
                  width: 200,
                ),
              ),
              Text("Pwaadw aw da And Hello"),
              Text("N")
            ],
          ),
          CustomProxy(
            child: Image.network(
              "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              fit: BoxFit.fill,
              colorBlendMode: BlendMode.difference,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomColumn extends MultiChildRenderObjectWidget {
  CustomColumn({
    Key? key,
    List<Widget> children = const [],
    Alignment alignment = Alignment.center,
  })  : _alignment = alignment,
        super(key: key, children: children);

  final Alignment _alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderCustomColumn(
      alignment: _alignment,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomColumn renderObject) {
    // TODO: implement updateRenderObject
    renderObject.alignment = _alignment;
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int flex = 0;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  RenderCustomColumn({
    required Alignment alignment,
  }) : _alignment = alignment;

  Alignment get alignment => _alignment;
  Alignment _alignment;
  @override
  void performLayout() {
    Size size = _performLayout(constraints, false);
    RenderBox? child = firstChild;
    // positioning childs
    child = firstChild;
    Offset childOffset = Offset(0, 0);
    while (child != null) {
      final CustomColumnParentData childParentData =
          child.parentData! as CustomColumnParentData;
      childParentData.offset = Offset(0, childOffset.dy);

      childOffset += Offset(0, child.size.height);

      child = childParentData.nextSibling;
    }
  }

  set alignment(Alignment alignment) {
    markNeedsLayout();
  }

  Size _performLayout(BoxConstraints constraints, bool isDry) {
    double height = 0;
    double width = 0;
    //int totalFlex = 0;

    RenderBox? child = firstChild;

    // For calculating flex height in column
    //double flexHeight = (constraints.maxHeight - height) / totalFlex;

    // calculating layout sizes
    while (child != null) {
      final CustomColumnParentData childParentData =
          child.parentData! as CustomColumnParentData;
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
            // maxHeight: child.size.height,
            maxWidth: constraints.maxWidth,
          ),
          parentUsesSize: true,
        );
        childSize = child.size;
      }

      height += childSize.height;
      width = math.max(width, childSize.width);
      child = childParentData.nextSibling;
    }
    size = constraints.constrain(Size(width, height));

    log(size.height.toString() + "  " + size.width.toString());
    return size;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    // TODO: implement computeDryLayout
    return _performLayout(constraints, true);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double height = 0;
    RenderBox? child = firstChild;

    while (child != null) {
      final CustomColumnParentData childParentData =
          child.parentData! as CustomColumnParentData;

      height += child.getMinIntrinsicHeight(width);

      child = childParentData.nextSibling;
    }

    log("Min Height-->" + height.toString());

    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double height = 0;
    RenderBox? child = firstChild;

    while (child != null) {
      final CustomColumnParentData childParentData =
          child.parentData! as CustomColumnParentData;

      height += child.getMaxIntrinsicHeight(width);

      child = childParentData.nextSibling;
    }

    log("Max Height-->" + height.toString());

    return height;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0;
    RenderBox? child = firstChild;

    while (child != null) {
      final CustomColumnParentData childParentData =
          child.parentData! as CustomColumnParentData;

      width = math.max(width, child.getMaxIntrinsicWidth(height));

      child = childParentData.nextSibling;
    }

    log("Max Width-->" + width.toString());

    return height;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    double width = 0;
    RenderBox? child = firstChild;

    while (child != null) {
      final CustomColumnParentData childParentData =
          child.parentData! as CustomColumnParentData;

      width = math.max(width, child.getMinIntrinsicWidth(height));

      child = childParentData.nextSibling;
    }

    log("Min Width-->" + width.toString());

    return height;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToFirstActualBaseline(baseline);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
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
  }
}
