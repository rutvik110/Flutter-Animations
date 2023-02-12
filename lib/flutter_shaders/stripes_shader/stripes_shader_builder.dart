import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:vector_math/vector_math.dart' as vec;

class StripesShaderBuilder extends StatefulWidget {
  const StripesShaderBuilder({
    Key? key,
    this.child,
    this.direction = 1.0,
    this.updateShaderInputs,
    this.builder,
  })  : assert(child == null || builder == null,
            "You can't provide both child and builder. Use builder as it offers more control over shader usage."),
        super(key: key);

  final Widget? child;
  final double direction;
  final StripesShaderArguments Function(
    FragmentShader fragmentShader,
    Size size,
    double delta,
  )? updateShaderInputs;

  final Widget Function(FragmentShader shader, double delta)? builder;

  @override
  State<StripesShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderBuilder> {
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
    return ShaderBuilder(
      (context, shader, child) {
        if (widget.builder != null) {
          return widget.builder!(shader, delta);
        }
        return AnimatedSampler(
          child: child!,
          (ui.Image image, Size size, Canvas canvas) {
            if (widget.updateShaderInputs != null) {
              shader = shader.shader(
                floatUniforms:
                    widget.updateShaderInputs!(shader, size, delta).uniforms,
                samplerUniforms: [],
              );
            } else {
              shader = shader.shader(
                floatUniforms: StripesShaderArguments(
                  size: size,
                  delta: delta,
                  tiles: 4.0,
                  speed: delta / 10,
                  direction: widget.direction, // -1 to 1
                  warpScale: 0.25,
                  warpTiling: 0.5,
                  color1: vec.Vector3(0.0, .032, 1.0),
                  color2: vec.Vector3(1.0, .003, .449),
                ).uniforms,
                samplerUniforms: [],
              );
            }

            canvas
              ..save()
              ..drawRect(
                Offset.zero & size,
                Paint()..shader = shader,
              )
              ..restore();
          },
        );
      },
      assetKey: "shaders/stripes.glsl",
      child: widget.child,
    );
    // FutureBuilder<Stripes>(
    //   future: helloWorld,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return widget.builder != null
    //           ? widget.builder!(context, snapshot.data!, delta)
    //           : ShaderMask(
    //               child: widget.child,
    //               shaderCallback: (rect) {
    //                 return snapshot.data!.shader(
    //                   resolution: rect.size,
    //                   uTime: delta,
    //                   tiles: 4.0,
    //                   speed: delta / 10,
    //                   direction: widget.direction, // -1 to 1
    //                   warpScale: 0.25,
    //                   warpTiling: 0.5,
    //                   color1: Vector3(0.0, .032, 1.0),
    //                   color2: Vector3(1.0, .003, .449),
    //                 );
    //               },
    //             );
    //     } else if (snapshot.hasError) {
    //       return Text('${snapshot.error}');
    //     }
    //     return const CircularProgressIndicator();
    //   },
    // ),
    //)
  }
}

class StripesShaderArguments {
  final Size size;
  final double delta;
  final double tiles;
  final double speed;
  final double direction;
  final double warpScale;
  final double warpTiling;
  final vec.Vector3 color1;
  final vec.Vector3 color2;

  StripesShaderArguments({
    required this.size,
    required this.delta,
    required this.tiles,
    required this.speed,
    required this.direction,
    required this.warpScale,
    required this.warpTiling,
    required this.color1,
    required this.color2,
  });

  Float32List get uniforms => Float32List.fromList([
        size.width,
        size.height,
        delta,
        tiles,
        speed,
        direction,
        warpScale,
        warpTiling,
        color1.x,
        color1.y,
        color1.z,
        color2.x,
        color2.y,
        color2.z,
      ]);
}
