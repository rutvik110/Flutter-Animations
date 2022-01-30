import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

class ParallaxWidget extends StatefulWidget {
  const ParallaxWidget({Key? key}) : super(key: key);

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  final TransformationController _transformationController =
      TransformationController();

  late final Animation<Alignment> parallaxAnimation;
  late final Animation<Offset> originPanAnimation;
  late final Animation<Matrix4> panAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );

    panAnimation = TweenSequence<Matrix4>([
      TweenSequenceItem(
        tween: Matrix4Tween(
          begin: Matrix4.identity()..scale(2.0, 2.0, 1.0),
          end: Matrix4.identity(),
        ),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Matrix4Tween(
          begin: Matrix4.identity(),
          end: Matrix4.identity(),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Matrix4Tween(
          begin: Matrix4.identity(),
          end: Matrix4.identity()..scale(1.5),
        ),
        weight: 3.0,
      ),
    ]).animate(animationController);
    originPanAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: Offset(0, 0),
          end: Offset(0, 0),
        ),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: Offset(0, 0),
          end: Offset(100, 0),
        ),
        weight: 1.0,
      ),
    ]).animate(animationController);

    parallaxAnimation = Tween<Alignment>(
      begin: Alignment(0, 0),
      end: Alignment(0.5, 0),
    )
        .chain(
          CurveTween(
            curve: Interval(0.2, 0.5),
          ),
        )
        .animate(
          animationController,
        );

    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: parallaxAnimation,
        builder: (context, child) {
          return Transform(
            transform: panAnimation.value,
            origin: originPanAnimation.value,
            child: Image.asset(
              "assets/images/parallax.jpeg",
              fit: BoxFit.cover,
              alignment: parallaxAnimation.value,
              height: double.maxFinite,
            ),
          );
        },
      ),
    );
  }
}
