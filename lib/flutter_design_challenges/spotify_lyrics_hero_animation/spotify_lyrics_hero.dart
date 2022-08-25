import 'package:flutter/material.dart';

class SpotifyLyricsHero extends StatelessWidget {
  const SpotifyLyricsHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "Lyrics",
                  placeholderBuilder: (context, size, child) {
                    return child;
                  },
                  child: SizedBox(
                    height: 300,
                    width: 200,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    onPressed: () {
                      navigateToLyrics(context);
                    },
                    icon: const Icon(
                      Icons.expand,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

void navigateToLyrics(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(
        seconds: 2,
      ),
      reverseTransitionDuration: const Duration(
        seconds: 2,
      ),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LyricsView(
          animation: animation,
        );
      },
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      }),
    ),
  );
}

class LyricsView extends StatelessWidget {
  const LyricsView({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final lyricsBox = SizedBox(
      width: double.maxFinite,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.yellow.shade700,
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          AnimatedBuilder(
              animation: animation,
              child: AppBar(),
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, -1), end: const Offset(0, 0))
                      .animate(animation),
                  child: child,
                );
              }),
          Expanded(
            child: AnimatedBuilder(
                animation: animation,
                child: Hero(
                  tag: "Lyrics",
                  flightShuttleBuilder: ((flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    return FadeTransition(opacity: animation, child: lyricsBox);
                  }),
                  child: lyricsBox,
                ),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }),
          ),
          AnimatedBuilder(
              animation: animation,
              child: Container(
                  height: 120, color: const Color.fromRGBO(244, 67, 54, 1)),
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 1), end: const Offset(0, 0))
                      .animate(animation),
                  child: child,
                );
              })
        ],
      ),
    );
  }
}
