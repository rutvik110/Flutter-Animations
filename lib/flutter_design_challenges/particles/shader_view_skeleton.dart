import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderViewSkeleton extends StatefulWidget {
  const ShaderViewSkeleton({
    super.key,
    required this.image,
    required this.shaderAssetKey,
    required this.updateShaderInputs,
  });

  final Widget image;
  final String shaderAssetKey;
  final FragmentShader Function(
    FragmentShader fragmentShader,
    Size size,
    double delta,
  ) updateShaderInputs;

  @override
  State<ShaderViewSkeleton> createState() => _MyShaderState();
}

class _MyShaderState extends State<ShaderViewSkeleton>
    with SingleTickerProviderStateMixin {
  late Ticker ticker;

  late double delta;

  FragmentShader? fragmentShader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    delta = 0;

    ticker = Ticker((elapsedTime) {
      if (mounted) {
        setState(() {
          delta += 1 / 60;
        });
      }
    });
    ticker.start();
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
        fragmentShader ??= shader;
        return ShaderMask(
            shaderCallback: (rect) {
              return widget.updateShaderInputs(
                  fragmentShader!, rect.size, delta);
            },
            child: child);
      },
      assetKey: widget.shaderAssetKey,
      child: widget.image,
    );
  }
}
