import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BouncingBall extends StatelessWidget {
  const BouncingBall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: RiveAnimation.asset(
            "assets/rive/bouncing_ball.riv",
          ),
        ),
      ),
    );
  }
}
