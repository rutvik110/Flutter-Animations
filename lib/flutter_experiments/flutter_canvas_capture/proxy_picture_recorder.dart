import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PictureRecorderCustomProxy extends SingleChildRenderObjectWidget {
  const PictureRecorderCustomProxy({
    Key? key,
    required Widget child,
    required this.savePicture,
  }) : super(key: key, child: child);

  final Function(ui.Picture picture) savePicture;

  @override
  RenderCustomProxy createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderCustomProxy(
      savePicture: savePicture,
    );
  }
}

class RenderCustomProxy extends RenderProxyBox {
  RenderCustomProxy({
    required this.savePicture,
  });
  final Function(ui.Picture picture) savePicture;

  @override
  void paint(PaintingContext context, Offset offset) async {
    // TODO: implement paint
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    context.paintChild(child!, offset);
    canvas.drawRect(
      Offset.zero & const Size(400, 400),
      ui.Paint()
        ..style = ui.PaintingStyle.fill
        ..color = Colors.red,
    );
    final picture = pictureRecorder.endRecording();

    savePicture(picture);
  }
}
