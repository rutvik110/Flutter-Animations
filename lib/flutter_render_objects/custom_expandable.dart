import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_render_objects/custom_render_objects.dart';

class CustomExpanded extends ParentDataWidget<CustomColumnParentData> {
  const CustomExpanded({Key? key, required Widget child})
      : super(key: key, child: child);
  //pretty handy if I want to update the parent data of the render object of this widget
  // like column has flexible widget which updates the flex on parent data for it's child
  @override
  void applyParentData(RenderObject renderObject) {}

  @override
  // TODO: implement debugTypicalAncestorWidgetClass
  Type get debugTypicalAncestorWidgetClass => CustomColumn;
}
