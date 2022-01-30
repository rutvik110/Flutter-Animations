import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomProxy extends SingleChildRenderObjectWidget {
  CustomProxy({
    Key? key,
    required this.child,
  }) : super(key: key, child: child);

  final Widget child;
  @override
  RenderCustomProxy createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderCustomProxy();
  }
}

class RenderCustomProxy extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    final canvas = context.canvas;

    canvas.saveLayer(
      offset & size,
      Paint()..blendMode = BlendMode.difference,
    );

    context.paintChild(child!, offset);
    canvas.restore();
  }
}
