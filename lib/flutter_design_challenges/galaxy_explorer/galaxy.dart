import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animations/flutter_design_challenges/galaxy_explorer/particle_system/bubble_stystem.dart';
import 'package:flutter_animations/flutter_design_challenges/galaxy_explorer/particle_system/bubble_stystem_painter.dart';
import 'package:flutter_animations/flutter_design_challenges/galaxy_explorer/radar/radar_painter.dart';

/// Fills all available space with stars that fly from left to right,
/// and spin.
class Galaxy extends StatefulWidget {
  const Galaxy({
    Key? key,
  }) : super(key: key);

  @override
  _GalaxyState createState() => _GalaxyState();
}

class _GalaxyState extends State<Galaxy> with TickerProviderStateMixin {
  late BubbleSystem bubbleSystem;
  late Ticker _ticker;
  Duration _lastTickTime = Duration.zero;
  late AnimationController animationController;
  late AnimationController radarController;

  late Animation<double> velocityAnimation;
  late Animation<double> countsAnimation;
  late Animation<double> planetSizeAnimation;

  late double radarAngle;
  late Timer spaceShipFlickerTimer;

  late double flickerValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    spaceShipFlickerTimer = Timer(Duration.zero, () {});
    flickerValue = 1.0;
    radarAngle = 0;
    _ticker = Ticker(_onTick)..start();
    radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ),
    );

    velocityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 100,
          end: 10000,
        ),
        weight: 0.9,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 10000,
          end: 100,
        ),
        weight: 0.1,
      ),
    ]).chain(CurveTween(curve: Curves.decelerate)).animate(animationController);
    countsAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 100,
          end: 5000,
        ),
        weight: 0.9,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 5000,
          end: 100,
        ),
        weight: 0.1,
      ),
    ]).chain(CurveTween(curve: Curves.decelerate)).animate(animationController);
    planetSizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 100,
          end: 1000,
        ),
        weight: 0.2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1000,
          end: 1000,
        ),
        weight: 0.95,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 100,
        ),
        weight: 0.05,
      ),
    ]).chain(CurveTween(curve: Curves.decelerate)).animate(animationController);

    animationController.addListener(() {
      setState(() {
        bubbleSystem.updateVelocity(velocityAnimation.value);
        bubbleSystem.updateCount(countsAnimation.value);
      });
      if (animationController.isCompleted) {
        spaceShipFlickerTimer.cancel();
        flickerValue = 1.0;
      }
    });

    bubbleSystem = BubbleSystem();
  }

  void _onTick(Duration elapsedTime) {
    final dt = elapsedTime - _lastTickTime;
    _lastTickTime = elapsedTime;
    bubbleSystem.update(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: BublleSystemPainter(
            bubbleSystem: bubbleSystem,
            angle: animationController
                .drive(Tween<double>(begin: 0, end: pi * 2))
                .value,
          ),
          size: Size.infinite,
        ),
        !animationController.isAnimating
            ? const SizedBox.shrink()
            : Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.overlay,
                    color: Colors.red.withOpacity(
                      1,
                    ),
                  ),
                ),
              ),
        // Positioned.fill(
        //   child: Image.asset(
        //     'assets/images/cockpit.png',
        //     fit: BoxFit.fill,
        //   ),
        // ),
        Positioned(
          bottom: 70,
          child: AnimatedBuilder(
            animation: radarController,
            builder: (context, child) {
              return CustomPaint(
                painter: RadarPainter(
                  angle: radarController
                      .drive(
                        Tween<double>(
                          begin: 0,
                          end: pi * 2,
                        ),
                      )
                      .value,
                ),
                size: const Size(
                  300,
                  300,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 2,
                  colors: const [
                    Colors.transparent,
                    Color.fromARGB(255, 10, 61, 13),
                  ],
                  stops: [
                    0.0,
                    flickerValue,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: ElevatedButton(
            onPressed: () {
              if (animationController.isCompleted) {
                spaceShipFlickerTimer = Timer.periodic(
                    const Duration(
                      milliseconds: 500,
                    ), (timer) {
                  setState(() {
                    flickerValue = flickerValue == 0.7 ? 1.0 : 0.7;
                  });
                });
                animationController
                  ..reset()
                  ..forward();
              } else if (animationController.isAnimating) {
              } else {
                spaceShipFlickerTimer = Timer.periodic(
                    const Duration(
                      milliseconds: 500,
                    ), (timer) {
                  setState(() {
                    flickerValue = flickerValue == 0.7 ? 1.0 : 0.7;
                  });
                });
                animationController.forward();
              }
            },
            child: const Text("Travel to the next galaxy"),
          ),
        ),
      ],
    );
  }
}
