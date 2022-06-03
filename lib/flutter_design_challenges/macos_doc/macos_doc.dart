import 'package:flutter/material.dart';

class MacOsDoc extends StatefulWidget {
  const MacOsDoc({Key? key}) : super(key: key);

  @override
  State<MacOsDoc> createState() => _MacOsDocState();
}

class _MacOsDocState extends State<MacOsDoc> {
  late final RenderBox renderObject;
  late bool isInitialized;

  late final GlobalKey key;

  late double doc_width;
  late double doc_default_width;
  late double hover_ratio;
  late double horizontal_position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isInitialized = false;
    key = GlobalKey();
    doc_width = 200;
    doc_default_width = doc_width;
    hover_ratio = 0;
    horizontal_position = 0;
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
            child: MouseRegion(
              key: key,
              onHover: ((event) {
                if (isInitialized) {
                  final Offset localPosition =
                      renderObject.globalToLocal(event.position);

                  final double x = localPosition.dx;
                  final double y = localPosition.dy;
                  final ratio = x / doc_width;
                  if (ratio < 0.5) {
                    final normalizedRatio = ratio * 2;
                    // log(normalizedRatio.toString());

                    // final addWidth = normalizedRatio * doc_default_width;
                    // log(addWidth.toString());
                    // doc_width = 200 + normalizedRatio > hover_ratio
                    //     ? addWidth
                    //     : -addWidth;

                    // hover_ratio = normalizedRatio;
                    setState(() {
                      hover_ratio = ratio;
                      horizontal_position = x;
                    });

                    // log('left');
                  } else {
                    final normalizedRatio = ratio * 2 - 1.0;
                    // final addWidth = normalizedRatio * doc_default_width;

                    setState(() {
                      hover_ratio = ratio;
                      horizontal_position = x;
                    });
                  }
                } else {
                  setState(() {
                    final renderbox =
                        key.currentContext!.findRenderObject() as RenderBox;
                    renderObject = renderbox;

                    isInitialized = true;
                  });
                }
              }),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          height: 50,
                          width: 50,
                          color: colors[i],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Color> colors = [Colors.red, Colors.blue, Colors.green];
