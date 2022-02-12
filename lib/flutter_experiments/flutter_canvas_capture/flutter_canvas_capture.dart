import 'dart:math' as math;
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const starWarsCrawlTextColor = Color(0xffc7890a);

class CanvasCapture extends StatefulWidget {
  const CanvasCapture({Key? key}) : super(key: key);

  @override
  State<CanvasCapture> createState() => _CanvasCaptureState();
}

class _CanvasCaptureState extends State<CanvasCapture>
    with SingleTickerProviderStateMixin {
  final String crawlText =
      '''Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute.

Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo.

While the Congress of the Republic endlessly debates this alarming chain of events,the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict....''';

  late final AnimationController _animationController;

  late final Animation<Offset> crawlTextposition;

  late final Animation<double> disappearCrawlText;

  late AudioCache audioPlayer = AudioCache(
    fixedPlayer: AudioPlayer(),
  );

  final scaffoldKey = GlobalKey();

  void playAnimation() async {
    final height = MediaQuery.of(context).size.height;
    final topOffset = height;
    final bottomOffset = -height * 0.8;
    crawlTextposition =
        Tween(begin: Offset(0, topOffset), end: Offset(0, bottomOffset))
            .animate(_animationController);
    disappearCrawlText = Tween<double>(begin: 1.0, end: 0)
        .chain(
          CurveTween(
            curve: const Interval(0.95, 1.0),
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
    await Future.delayed(const Duration(milliseconds: 500));
    // await audioPlayer.play(
    //   "audio/about_music.mp3",
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    _animationController.addListener(() async {
      // final RenderRepaintBoundary boundary = scaffoldKey.currentContext!
      //     .findRenderObject() as RenderRepaintBoundary;
      // var image = await boundary.toImage();
      // var byteData = await image.toByteData(format: ImageByteFormat.png);
      // var pngBytes = byteData!.buffer.asUint8List();
      // print(pngBytes);

      // final Directory appDocDir = await getApplicationDocumentsDirectory();

      // final Directory directory = Directory("${appDocDir.path}/canvas_images");

      // final File file =
      //     File("${directory.path}/${math.Random().nextInt(1000)}.png");

      // file.writeAsBytes(pngBytes);
    });
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
    audioPlayer.fixedPlayer!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RepaintBoundary(
        key: scaffoldKey,
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/galaxy.png',
                    fit: BoxFit.cover,
                  ),
                ),
                CrawlText(
                  animationController: _animationController,
                  crawlText: crawlText,
                  crawlTextposition: crawlTextposition,
                  disappearCrawlText: disappearCrawlText,
                ),
                const BackButton(),
              ],
            )),
      ),
    );
  }
}

class CrawlText extends StatelessWidget {
  const CrawlText({
    Key? key,
    required AnimationController animationController,
    required this.crawlText,
    required this.crawlTextposition,
    required this.disappearCrawlText,
  })  : _animationController = animationController,
        super(key: key);

  final AnimationController _animationController;
  final String crawlText;
  final Animation<Offset> crawlTextposition;
  final Animation<double> disappearCrawlText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        child: Transform(
          origin: Offset(
            MediaQuery.of(context).size.width / 2, //540,
            150,
          ),
          transform: Matrix4.identity()
            ..setRotationX(
              math.pi / 2.7, //2.8, //2.5,
            )
            ..setEntry(
              3,
              1,
              -0.001,
            ),
          child: AnimatedBuilder(
              animation: _animationController,
              child: CrawlContributions(
                animationController: _animationController,
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
    );
  }
}

class CrawlContributions extends StatelessWidget {
  const CrawlContributions({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final crawlBodyTextStyle = TextStyle(
      height: 1.3,
      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
      color: starWarsCrawlTextColor,
      fontFamily: "Crawl",
    );

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final maxdrag = details.primaryDelta!;

        final isScrolledDown = maxdrag.isNegative;

        final animationValue = animationController.value;
        animationController
            .animateTo(
          isScrolledDown ? (animationValue + 0.1) : (animationValue - 0.1),
          duration: const Duration(milliseconds: 300),
        )
            .then((value) {
          if (!isScrolledDown) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.3),
        child: ListView(
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Text(
              "ChaseApp Development Credits",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.3,
                color: starWarsCrawlTextColor,
                fontFamily: "Crawl",
              ),
            ),
            const Divider(
              height: 20,
            ),
            Text(
              "A special thank you goes out to all those that have helped contribute code, ideas, and with the overall care and feeding of the system, we salute you.",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: crawlBodyTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: "# ",
                  style: crawlBodyTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "Chases IRC team",
                  style: crawlBodyTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 10,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ]),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: "# ",
                  style: crawlBodyTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "Chases Private Channel",
                  style: crawlBodyTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 10,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ]),
            ),
            const Divider(
              height: 10,
            ),
            Text(
              "Thank You!",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.3,
                fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                color: starWarsCrawlTextColor,
                fontFamily: "Crawl",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    Key? key,
    required this.name,
    required this.link,
  }) : super(key: key);

  final String name;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: starWarsCrawlTextColor,
              child: Text(
                name.characters.first.toUpperCase(),
              ),
            ),
            Chip(
              backgroundColor: Colors.white.withOpacity(
                0.6,
              ),
              avatar: const Icon(
                Icons.link,
                color: starWarsCrawlTextColor,
              ),
              label: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//  savePicture: (picture) async {
//             final Directory appDocDir =
//                 await getApplicationDocumentsDirectory();

//             final Directory directory =
//                 Directory("${appDocDir.path}/canvas_images");

//             final File file =
//                 File("${directory.path}/${math.Random().nextInt(1000)}.png");

//             picture.toImage(400, 400).then((image) async {
//               final bytesData =
//                   await image.toByteData(format: ImageByteFormat.png);
//               final bytesList = bytesData!.buffer.asUint8List();
//             });
//           },