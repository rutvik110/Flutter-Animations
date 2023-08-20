import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/hearts_special_experience/shader_view_skeleton.dart';

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
              isActive: true,
              shaderAssetKey: 'shaders/cellular_noise.glsl',
              image: const ColoredBox(
                color: Colors.white,
              ),
              updateShaderInputs: (fragmentShader, image, size, delta) {
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

class GradientBallBuilder extends StatelessWidget {
  const GradientBallBuilder({
    super.key,
    required this.dragPoint,
  });

  final Offset dragPoint;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 2,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderViewSkeleton(
              isActive: true,
              shaderAssetKey: 'shaders/gradient_ball.glsl',
              image: const ColoredBox(
                color: Colors.white,
              ),
              updateShaderInputs: (fragmentShader, image, size, delta) {
                return fragmentShader
                  ..setFloat(0, delta)
                  ..setFloat(0, size.width)
                  ..setFloat(1, size.height)
                  ..setFloat(2, dragPoint.dx)
                  ..setFloat(3, dragPoint.dy);
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

class AnimeWarpBuilder extends StatelessWidget {
  const AnimeWarpBuilder({
    super.key,
    required this.dragPoint,
    required this.child,
    required this.noiseStretchFactor,
  });

  final Offset dragPoint;
  final Widget child;
  final double noiseStretchFactor;

  @override
  Widget build(BuildContext context) {
    return ShaderViewSkeleton(
      isActive: true,
      shaderAssetKey: 'shaders/anime_warp.glsl',
      image: child,
      updateShaderInputs: (fragmentShader, image, size, delta) {
        return fragmentShader
          ..setFloat(0, size.width)
          ..setFloat(1, size.height)
          ..setFloat(2, delta)
          ..setFloat(3, dragPoint.dx)
          ..setFloat(4, dragPoint.dy)
          ..setFloat(5, noiseStretchFactor)
          ..setImageSampler(0, image);
      },
    );
  }
}

class AirDropEffectBuilder extends StatelessWidget {
  const AirDropEffectBuilder({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderViewSkeleton(
      isActive: true,
      shaderAssetKey: 'shaders/airdrop.glsl',
      image: child,
      updateShaderInputs: (fragmentShader, image, size, delta) {
        return fragmentShader
          ..setFloat(0, size.width)
          ..setFloat(1, size.height)
          ..setFloat(2, delta)
          ..setImageSampler(0, image);
      },
    );
  }
}
