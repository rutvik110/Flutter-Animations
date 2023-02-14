import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/particles/shader_view_skeleton.dart';

class CellularNoiseBuilder extends StatelessWidget {
  const CellularNoiseBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderViewSkeleton(
              shaderAssetKey: 'shaders/cellular_noise.glsl',
              image: const ColoredBox(
                color: Colors.white,
              ),
              updateShaderInputs: (fragmentShader, size, delta) {
                return fragmentShader
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, delta);
              },
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: const SizedBox.expand(),
          )
        ],
      ),
    );
  }
}
