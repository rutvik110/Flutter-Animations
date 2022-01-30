import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class StarWardsIntro extends StatefulWidget {
  const StarWardsIntro({Key? key}) : super(key: key);

  @override
  State<StarWardsIntro> createState() => _StarWardsIntroState();
}

class _StarWardsIntroState extends State<StarWardsIntro>
    with SingleTickerProviderStateMixin {
  final String crawlText =
      '''Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute.

Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo.

While the Congress of the Republic endlessly debates this alarming chain of events,the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict....''';

  late final AnimationController _animationController;

  late final Animation<Offset> crawlTextposition;

  late final Animation<double> disappearCrawlText;

  late AudioCache audioPlayer = AudioCache();

  void playAnimation() {
    final height = MediaQuery.of(context).size.height;
    final topOffset = height + 100;
    final bottomOffset = -height / 2;
    crawlTextposition =
        Tween(begin: Offset(0, topOffset), end: Offset(0, bottomOffset))
            .animate(_animationController);
    disappearCrawlText = Tween<double>(begin: 1.0, end: 0)
        .chain(
          CurveTween(
            curve: Interval(0.9, 0.95),
          ),
        )
        .animate(_animationController);

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  Future<void> playTrack() async {
    await audioPlayer.load("star_wars_intro.mp3");
    await audioPlayer.play("star_wars_intro.mp3");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    // playAnimation();
    playTrack();
  }

  @override
  void didChangeDependencies() {
    playAnimation();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/galaxy.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3, //370,
                height: 500,
                child: Transform(
                  origin: Offset(
                    MediaQuery.of(context).size.width / 2 -
                        MediaQuery.of(context).size.width * 0.37, //540,
                    150,
                  ),
                  transform: Matrix4.identity()
                    ..setRotationX(
                      pi / 2.5, //2.8, //2.5,
                    )
                    ..setEntry(
                      3,
                      1,
                      -0.001,
                    ),
                  child: AnimatedBuilder(
                      animation: _animationController,
                      child: Text(
                        crawlText,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xffc7890a),
                          fontFamily: "Crawl",
                        ),
                      ),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: crawlTextposition.value,
                          child: Opacity(
                            opacity: disappearCrawlText.value,
                            child: child,
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ));
  }
}
