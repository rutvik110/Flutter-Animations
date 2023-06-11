import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class ScrollingDonuts extends StatefulWidget {
  const ScrollingDonuts({super.key});

  @override
  State<ScrollingDonuts> createState() => _ScrollingDonutsState();
}

class _ScrollingDonutsState extends State<ScrollingDonuts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: DonutWheelPainter(),
              ),
            ),
            SizedBox(
              height: 500,
              child: ListCurvedView(
                childrens:
                    //     List.generate(12, (index) {
                    //   return AspectRatio(
                    //     aspectRatio: 1,
                    //     child: Image.asset(
                    //       'assets/images/pokemons/${index + 1}.png',
                    //     ),
                    //   );
                    // })

                    [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/images/donut_1.png',
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/images/donut_2.png',
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/images/donut_3.png',
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/images/donut_1.png',
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/images/donut_2.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListCurvedView extends StatefulWidget {
  const ListCurvedView({
    Key? key,
    required this.childrens,
  }) : super(key: key);

  final List<Widget> childrens;

  @override
  State<ListCurvedView> createState() => _ListCurvedViewState();
}

class _ListCurvedViewState extends State<ListCurvedView> {
  late final PageController pageController;
  static const double degree = math.pi / 180;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      viewportFraction: 0.3,
      initialPage: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: widget.childrens.length,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      onPageChanged: (value) {},
      itemBuilder: ((context, index) {
        return AnimatedBuilder(
            animation: pageController,
            child: widget.childrens[index],
            builder: (context, child) {
              final position = pageController.position;
              late final double value;
              if (position.hasPixels && position.hasContentDimensions) {
                var page = pageController.page;
                if (page != null) {
                  value = page - index;
                }
              } else {
                BuildContext storageContext = pageController.position.context.storageContext;
                final double? previousSavedPosition =
                    PageStorage.of(storageContext).readState(storageContext) as double?;
                if (previousSavedPosition != null) {
                  value = previousSavedPosition - index.toDouble();
                } else {
                  value = pageController.initialPage - index.toDouble();

                  log(value.toString());
                }
              }
              final double distortionRatio = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
              const offset = 0.5;
              final beforeLerp = lerpDouble(0, 0.5, value.abs())!;
              final scalingValue = beforeLerp + offset;

              final lastValue = scalingValue >= 1.0 ? lerpDouble(1 + offset, 1, scalingValue) : scalingValue;
              final distortionValue = Curves.linear.transform(distortionRatio);
              if (index == 3) {
                log(value.toString());
              }

              return Center(
                child: Opacity(
                  opacity: distortionValue,
                  child: Transform.translate(
                    offset: Offset(
                      // 0, 0,
                      0,
                      // -(value.abs() * 100).toDouble(),
                      -(value * 100).toDouble(),
                    ),
                    child: Transform.scale(
                      scale: distortionValue,
                      child: Transform.rotate(
                        angle: value * 45 * degree * 10,
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}

class DonutWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 0.35,
        size.width,
        size.height * 0.2,
      )
      ..lineTo(size.width, size.height * 0.7)
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 0.8,
        0,
        size.height * 0.7,
      )
      ..close();
    canvas.drawPath(
      path,
      Paint()..color = Colors.pink,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
