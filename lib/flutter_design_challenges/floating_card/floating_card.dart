import 'dart:math';

import 'package:flutter/material.dart';

class FloatingCard extends StatefulWidget {
  const FloatingCard({Key? key}) : super(key: key);

  @override
  State<FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<FloatingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  late final Animation<double> animation;
  late final Animation<double> gradientStopAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    animation = Tween<double>(begin: 0, end: pi).animate(animationController);
    gradientStopAnimation =
        Tween<double>(begin: 0, end: 1).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                print(gradientStopAnimation.value);
                return Transform(
                  transform:
                      // MatrixUtils.createCylindricalProjectionTransform(
                      //   radius: 100,
                      //   angle: animation.value,
                      //   orientation: Axis.horizontal,
                      // ),

                      Matrix4.identity()
                        ..rotateY(animation.value)
                        ..setEntry(
                          2,
                          1,
                          0.002,
                        ),
                  alignment: Alignment.center,
                  child: Container(
                    height: 600,
                    width: 300,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        tileMode: TileMode.mirror,
                        colors: [
                          Colors.red.withOpacity(0.3),
                          Colors.white.withOpacity(0.5),
                          Colors.red.withOpacity(0.3),
                        ],
                        stops: [
                          0.0,
                          gradientStopAnimation.value,
                          1.0,
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          animation.value >= pi / 2
                              ? "assets/queen.png"
                              : "assets/joker.png",
                        ),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      color:
                          animation.value >= pi / 2 ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              })),
    );
  }
}
