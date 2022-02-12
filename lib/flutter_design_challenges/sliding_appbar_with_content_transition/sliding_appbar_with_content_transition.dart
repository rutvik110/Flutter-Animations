import 'package:flutter/material.dart';

class SlidingAppBarWithContentTransition extends StatelessWidget {
  const SlidingAppBarWithContentTransition({Key? key}) : super(key: key);

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 50),
      reverseTransitionDuration: const Duration(milliseconds: 50),
      pageBuilder: (context, animation, secondaryAnimation) {
        final appbarOffsetAnimation = Tween<Offset>(
          begin: const Offset(
            0,
            -kToolbarHeight,
          ),
          end: const Offset(0, 0),
        )
            .chain(
              CurveTween(
                curve: Curves.decelerate,
              ),
            )
            .animate(animation);
        final bottomListAnimation = Tween<Offset>(
          begin: Offset(
            0,
            MediaQuery.of(context).size.height,
          ),
          end: const Offset(0, 0),
        )
            .chain(
              CurveTween(
                curve: Curves.decelerate,
              ),
            )
            .animate(animation);
        return ContentView(
          appBarOffsetAnimation: appbarOffsetAnimation,
          bottomListAnimation: bottomListAnimation,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset(
            0,
            MediaQuery.of(context).size.height,
          ),
          end: Offset.zero,
        )
            .chain(
              CurveTween(
                curve: Curves.decelerate,
              ),
            )
            .animate(animation);

        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, _createRoute());
          },
          child: Hero(
            tag: 'image',
            child: Image.network(
              "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80",
              height: 300,
              width: 300,
            ),
          ),
        ),
      ),
    );
  }
}

class ContentView extends StatelessWidget {
  const ContentView({
    Key? key,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
  }) : super(key: key);

  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedBuilder(
            animation: appBarOffsetAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: appBarOffsetAnimation.value,
                child: child,
              );
            },
            child: AppBar(),
          ),
          Hero(
            tag: 'image',
            child: Image.network(
              "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80",
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: bottomListAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: bottomListAnimation.value,
                  child: child,
                );
              },
              child: Transform.translate(
                offset: bottomListAnimation.value,
                child: ListView.builder(itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('$index'),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
