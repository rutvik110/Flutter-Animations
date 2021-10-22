import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/color_pallete.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> blueBoxHeightAnimation;
  late Animation<double> whiteBoxHeightAnimation;
  late Animation<double> logoOpacityAnimation;
  late Animation<double> logoSizeAnimation;

  late Animation<double> commonFadeSlideAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    blueBoxHeightAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: 1).chain(
              CurveTween(curve: Curves.fastOutSlowIn),
            ),
            weight: 0.25),
        TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 0.41),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1, end: 0.5).chain(
              CurveTween(curve: Curves.decelerate),
            ),
            weight: 0.33),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.75),
      ),
    );

    whiteBoxHeightAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.75, curve: Curves.decelerate),
      ),
    );

    logoOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.25, 0.35, curve: Curves.fastOutSlowIn),
      ),
    );
    logoSizeAnimation = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.75, curve: Curves.decelerate),
      ),
    );

    commonFadeSlideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.65, 0.9, curve: Curves.decelerate),
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlueBox(
                  blueBoxHeightAnimation: blueBoxHeightAnimation,
                  commonFadeSlideAnimation: commonFadeSlideAnimation,
                  logoOpacityAnimation: logoOpacityAnimation,
                  logoSizeAnimation: logoSizeAnimation,
                ),
                WhiteBox(
                  whiteBoxHeightAnimation: whiteBoxHeightAnimation,
                  commonFadeSlideAnimation: commonFadeSlideAnimation,
                ),
              ],
            );
          }),
    );
  }
}

class WhiteBox extends StatelessWidget {
  const WhiteBox({
    Key? key,
    required this.whiteBoxHeightAnimation,
    required this.commonFadeSlideAnimation,
  }) : super(key: key);

  final Animation<double> whiteBoxHeightAnimation;
  final Animation<double> commonFadeSlideAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * whiteBoxHeightAnimation.value,
      child: SlideFadeWidget(
        commonFadeSlideAnimation: commonFadeSlideAnimation,
        child: const LogInForm(),
      ),
    );
  }
}

class LogInForm extends StatelessWidget {
  const LogInForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextField(
            decoration: InputDecoration(
                labelText: "Email",
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: kDarkGrey),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kOffGrey))),
          ),
          const SizedBox(
            height: 25,
          ),
          const TextField(
            decoration: InputDecoration(
                labelText: "Password",
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: kDarkGrey),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kOffGrey))),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Forgot your password?",
            style: TextStyle(color: kOffGrey),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: const ContinuousRectangleBorder(),
                elevation: 10,
                shadowColor: kButtonShadowColor,
                fixedSize: const Size(double.maxFinite, 50),
              ),
              onPressed: () {},
              child: const Text(
                'Log In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ))
        ],
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
  const BlueBox({
    Key? key,
    required this.blueBoxHeightAnimation,
    required this.commonFadeSlideAnimation,
    required this.logoOpacityAnimation,
    required this.logoSizeAnimation,
  }) : super(key: key);

  final Animation<double> blueBoxHeightAnimation;
  final Animation<double> commonFadeSlideAnimation;
  final Animation<double> logoOpacityAnimation;
  final Animation<double> logoSizeAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * blueBoxHeightAnimation.value,
      color: kPrimaryColor,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          const Spacer(),
          Logo(
            logoOpacityAnimation: logoOpacityAnimation,
            logoSizeAnimation: logoSizeAnimation,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideFadeWidget(
              commonFadeSlideAnimation: commonFadeSlideAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("LOG IN",
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: true ? Colors.white : Colors.white60,
                            fontSize: true ? 27 : 15,
                          )),
                  Text(
                    "SIGN UP",
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: false ? Colors.white : Colors.white60,
                          fontSize: false ? 27 : 15,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    required this.logoOpacityAnimation,
    required this.logoSizeAnimation,
  }) : super(key: key);

  final Animation<double> logoOpacityAnimation;
  final Animation<double> logoSizeAnimation;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: logoOpacityAnimation.value,
      child: Icon(
        Icons.star,
        color: Colors.white,
        size: logoSizeAnimation.value * 150,
      ),
    );
  }
}

class SlideFadeWidget extends StatelessWidget {
  const SlideFadeWidget({
    Key? key,
    required this.commonFadeSlideAnimation,
    required this.child,
  }) : super(key: key);

  final Animation<double> commonFadeSlideAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
          MediaQuery.of(context).size.width *
              (1 - commonFadeSlideAnimation.value),
          0),
      child: Opacity(
        opacity: commonFadeSlideAnimation.value,
        child: child,
      ),
    );
  }
}
