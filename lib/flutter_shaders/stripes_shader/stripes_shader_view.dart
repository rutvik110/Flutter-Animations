import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes_shader_builder.dart';
import 'package:flutter_animations/util/extensions/colot_to_vector.dart';

class StripesShaderView extends StatefulWidget {
  const StripesShaderView({Key? key}) : super(key: key);

  @override
  State<StripesShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderView> {
  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    delta = 0;
    ticker = Ticker((elapsedTime) {
      setState(() {
        delta += 1 / 60;
      });
    })
      ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StripesShaderBuilder(
                direction: 1.0,
                builder: (shader, delta) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      shader = shader.shader(
                        floatUniforms: StripesShaderArguments(
                          size: bounds.size,
                          delta: delta,
                          tiles: 4.0,
                          speed: delta / 10,
                          direction: -.8, // -1 to 1
                          warpScale: 0.5,
                          warpTiling: 0.3,
                          color1: Colors.red.toColorVector(),
                          color2: Colors.blue.toColorVector(),
                        ).uniforms,
                        samplerUniforms: [],
                      );
                      return shader;
                    },
                    child: const Text(
                      "Stylized Text",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 60,
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  backgroundBuilder: (context, setState, child) {
                    return StripesShaderBuilder(
                      direction: 1.0,
                      builder: (shader, delta) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: StripesShaderBuilder(
                                direction: 1.0,
                                child: Container(
                                  color: Colors.white,
                                ),
                                updateShaderInputs: (shader, size, delta) {
                                  return StripesShaderArguments(
                                    size: size,
                                    delta: delta,
                                    tiles: 3.0,
                                    speed: delta / 10,
                                    direction: 0.5, // -1 to 1
                                    warpScale: 0.1,
                                    warpTiling: 0.5,
                                    color1: Colors.red.toColorVector(),
                                    color2: Colors.blue.toColorVector(),
                                  );
                                },
                              ),
                            ),
                            child!,
                          ],
                        );
                      },
                    );
                  },
                ),
                onPressed: () {},
                child: const Text(
                  "Stylized Button Backgrounds",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: StripesShaderBuilder(
              //         direction: 1.0,
              //         child: Container(
              //           height: 300,
              //           color: Colors.white,
              //         ),
              //         updateShaderInputs: (shader, size, delta) {
              //           return StripesShaderArguments(
              //             size: size,
              //             delta: delta,
              //             tiles: 4.0,
              //             speed: delta / 10,
              //             direction: -.8, // -1 to 1
              //             warpScale: 0.5,
              //             warpTiling: 0.8,
              //             color1: Colors.red.toColorVector(),
              //             color2: Colors.blue.toColorVector(),
              //           );
              //         },
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Expanded(
              //       child: StripesShaderBuilder(
              //         direction: 1.0,
              //         child: Container(
              //           height: 300,
              //           decoration: const BoxDecoration(
              //             color: Colors.white,
              //             shape: BoxShape.circle,
              //           ),
              //         ),
              //         updateShaderInputs: (shader, size, delta) {
              //           return StripesShaderArguments(
              //             size: size,
              //             delta: delta,
              //             tiles: 6.0,
              //             speed: delta / 10,
              //             direction: .5, // -1 to 1
              //             warpScale: 0.5,
              //             warpTiling: 0.8,
              //             color1: Colors.red.toColorVector(),
              //             color2: Colors.blue.toColorVector(),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 50,
              //         clipBehavior: Clip.hardEdge,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(100),
              //         ),
              //         child: const StripesShaderBuilder(
              //           direction: 1.0,
              //           child: ColoredBox(
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // StripesShaderBuilder(
              //   direction: 1.0,
              //   builder: (shader, delta) {
              //     return ShaderMask(
              //       shaderCallback: (bounds) {
              //         shader = shader.shader(
              //           floatUniforms: StripesShaderArguments(
              //             size: bounds.size,
              //             delta: delta,
              //             tiles: 4.0,
              //             speed: delta / 10,
              //             direction: -.8, // -1 to 1
              //             warpScale: 0.5,
              //             warpTiling: 0.3,
              //             color1: Colors.red.toColorVector(),
              //             color2: Colors.blue.toColorVector(),
              //           ).uniforms,
              //           samplerUniforms: [],
              //         );
              //         return shader;
              //       },
              //       child: const Text(
              //         "Shaders",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 60,
              //         ),
              //       ),
              //     );
              //   },
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // StripesShaderBuilder(
              //   direction: 1.0,
              //   builder: (shader, delta) {
              //     const size = Size(
              //       250,
              //       250,
              //     );
              //     shader = shader.shader(
              //         floatUniforms: StripesShaderArguments(
              //       size: size,
              //       delta: delta,
              //       tiles: 5.0,
              //       speed: delta / 20,
              //       direction: 0.7, // -1 to 1
              //       warpScale: 0.5,
              //       warpTiling: 0.5, color1: Colors.red.toColorVector(),
              //       color2: Colors.blue.toColorVector(),
              //     ).uniforms);
              //     return CustomPaint(
              //       painter: MyPainter(
              //         shader,
              //       ),
              //       size: size,
              //     );
              //   },
              // ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.shader) : _paint = Paint()..shader = shader;

  final Shader shader;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    // draw heart

    canvas.translate(size.width / 2, size.height / 2);

    const double heartRadius = 10;

    final angle = calculateAngleBasedOnPoints(360);

    final path = Path();

    for (var i = 0; i < 360; i++) {
      //calculate the angle of point
      double pointAngleValue = angle * i;

      //calculate the x and y coordinates of the point
      final offset = calculatePointOffset(angle: pointAngleValue, radius: heartRadius);
      path.lineTo(offset.dx, offset.dy);
    }

    canvas.drawPath(
      path,
      _paint,
    );
  }

  double calculateAngleBasedOnPoints(int points) {
    return pi * 2 / points;
  }

  Offset calculatePointOffset({required double angle, required double radius}) {
    return Offset(
      16 * pow(sin(angle), 3) * radius,
      -radius * (13 * cos(angle) - 5 * cos(angle * 2) - 2 * cos(angle * 3) - cos(angle * 4)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
