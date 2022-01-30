import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_render_objects/custom_render_objects.dart';
import 'dart:math' as math;

// Don't change unncessarily. You need to tell them to how and when to update.
class CustomBox extends LeafRenderObjectWidget {
  const CustomBox({Key? key, this.flex = 0}) : super(key: key);
  final int flex;
  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderCustomBox(flex: flex);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomBox renderObject) {
    // TODO: implement updateRenderObject
    renderObject.updateFlex = flex;
  }
}

class RenderCustomBox extends RenderBox {
  RenderCustomBox({
    required this.flex,
  });

  int flex;

  set updateFlex(int value) {
    assert(value >= 0);
    if (value != flex) {
      flex = value;
      // Parent needs to update coze we are changing something on the parent data.
      parentData!.flex = value;
      markParentNeedsLayout();
    }
  }

  @override
  CustomColumnParentData? get parentData {
    if (super.parentData == null) return null;

    assert(super.parentData! is CustomColumnParentData,
        "super.parentData is $CustomColumnParentData, $CustomBox can only be direct child of $CustomColumn");

    return super.parentData! as CustomColumnParentData;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    parentData!.flex = flex;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    // TODO: implement computeDryLayout
    return constraints.smallest;
  }

  @override
  // TODO: When size doesn't depend on childrens, make it true and calculate size by comupteDryLayout
  bool get sizedByParent => true;
  // Layers, same canvas passed down,eg. of Transform using context.pushTransform
  // canvas passed down one by one after each child
  // @override
  void paint(PaintingContext context, Offset offset) {
    // // TODO: implement paint
    final canvas = context.canvas;
    // canvas.save();
    // canvas.rotate(math.pi / 10);
    // // canvas.restore();

    canvas.drawRect(offset & size, Paint()..color = Color(0xFF124114));
  }

  //TODO Add gesture handling
  //read Events, HitTesting, GestureArena, Pointers, attaching a recognizer and detaching it

  // //Repaintboundary
  // Child paints separately, so it doesn't need to repaint itself when any other
  // childrens of parent or parent itself is marked as dirty.
  @override
  // TODO: implement isRepaintBoundary
  bool get isRepaintBoundary => true;

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    // TODO: implement describeSemanticsConfiguration
    config
      ..isButton = true
      ..textDirection = TextDirection.ltr
      ..label = "CustomBox"
      ..hint = "This is really cool!";
  }
}
