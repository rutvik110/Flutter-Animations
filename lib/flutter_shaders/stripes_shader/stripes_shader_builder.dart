import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes.dart';

class StripesShaderBuilder extends StatefulWidget {
  const StripesShaderBuilder({
    Key? key,
    this.child,
    required this.direction,
    this.builder,
  })  : assert(child == null || builder == null,
            "You can't provide both child and builder. Use builder as it offers more control over shader usage."),
        super(key: key);

  final Widget? child;
  final double direction;
  final Widget Function(BuildContext context, Stripes shader, double uTime)?
      builder;

  @override
  State<StripesShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderBuilder> {
  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = Stripes.compile();
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
      backgroundColor: Colors.black,
      body: FutureBuilder<Stripes>(
        future: helloWorld,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return widget.builder != null
                ? widget.builder!(context, snapshot.data!, delta)
                : ShaderMask(
                    child: widget.child,
                    shaderCallback: (rect) {
                      return snapshot.data!.shader(
                        resolution: rect.size,
                        uTime: delta,
                        tiles: 4.0,
                        speed: delta / 10,
                        direction: widget.direction, // -1 to 1
                        warpScale: 0.25,
                        warpTiling: 0.5,
                        color1: Vector3(0.0, .032, 1.0),
                        color2: Vector3(1.0, .003, .449),
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
