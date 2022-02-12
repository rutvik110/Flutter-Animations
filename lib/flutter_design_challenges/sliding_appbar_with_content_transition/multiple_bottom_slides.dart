import 'package:flutter/material.dart';

class MultipleSlidingAppBarWithContentTransition extends StatelessWidget {
  const MultipleSlidingAppBarWithContentTransition({Key? key})
      : super(key: key);

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 100),
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
                curve: const Interval(
                  0,
                  0.3,
                  curve: Curves.decelerate,
                ),
              ),
            )
            .animate(animation);
        final containerOneAnimation = Tween<Offset>(
          begin: Offset(
            0,
            MediaQuery.of(context).size.height,
          ),
          end: const Offset(0, 0),
        )
            .chain(
              CurveTween(
                curve: const Interval(
                  0,
                  0.3,
                ),
              ),
            )
            .animate(animation);
        final containerTwoAnimation = Tween<Offset>(
          begin: Offset(
            0,
            MediaQuery.of(context).size.height,
          ),
          end: const Offset(0, 0),
        )
            .chain(
              CurveTween(
                curve: const Interval(
                  0.3,
                  0.6,
                ),
              ),
            )
            .animate(animation);
        final containerThreeAnimation = Tween<Offset>(
          begin: Offset(
            0,
            MediaQuery.of(context).size.height,
          ),
          end: const Offset(0, 0),
        )
            .chain(
              CurveTween(
                curve: const Interval(
                  0.6,
                  0.9,
                ),
              ),
            )
            .animate(animation);
        return ContentView(
          appBarOffsetAnimation: appbarOffsetAnimation,
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

class ContentView extends StatefulWidget {
  const ContentView({
    Key? key,
    required this.appBarOffsetAnimation,
  }) : super(key: key);

  final Animation<Offset> appBarOffsetAnimation;

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Offset> boxOneAnimation;
  late final Animation<Offset> boxTwoAnimation;
  late final Animation<Offset> boxThreeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    boxOneAnimation = Tween<Offset>(
      begin: const Offset(0, 1000),
      end: Offset.zero,
    )
        .chain(
          CurveTween(
            curve: const Interval(
              0,
              0.5,
              curve: Curves.decelerate,
            ),
          ),
        )
        .animate(animationController);
    boxTwoAnimation = Tween<Offset>(
      begin: const Offset(0, 1000),
      end: Offset.zero,
    )
        .chain(
          CurveTween(
            curve: const Interval(
              0.1,
              0.7,
              curve: Curves.decelerate,
            ),
          ),
        )
        .animate(animationController);
    boxThreeAnimation = Tween<Offset>(
      begin: const Offset(0, 1000),
      end: Offset.zero,
    )
        .chain(
          CurveTween(
            curve: const Interval(
              0.3,
              0.9,
              curve: Curves.decelerate,
            ),
          ),
        )
        .animate(animationController);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await animationController.reverse();

        return true;
      },
      child: Scaffold(
        body: ListView(
          children: [
            AnimatedBuilder(
              animation: widget.appBarOffsetAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: widget.appBarOffsetAnimation.value,
                  child: child,
                );
              },
              child: AppBar(),
            ),
            Hero(
              tag: 'image',
              child: Image.network(
                "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80",
                height: 300,
                width: double.maxFinite,
              ),
            ),
            AnimatedBuilder(
              animation: boxOneAnimation,
              child: Container(
                height: 200,
                color: Colors.red,
              ),
              builder: (context, child) {
                return Transform.translate(
                  offset: boxOneAnimation.value,
                  child: child,
                );
              },
            ),
            AnimatedBuilder(
              animation: boxTwoAnimation,
              child: Container(
                height: 200,
                color: Colors.green,
              ),
              builder: (context, child) {
                return Transform.translate(
                  offset: boxTwoAnimation.value,
                  child: child,
                );
              },
            ),
            AnimatedBuilder(
              animation: boxThreeAnimation,
              child: Container(
                height: 200,
                color: Colors.yellow,
              ),
              builder: (context, child) {
                return Transform.translate(
                  offset: boxThreeAnimation.value,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
