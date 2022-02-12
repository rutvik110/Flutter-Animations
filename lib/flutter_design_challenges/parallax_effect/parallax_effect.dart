import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ParallaxWidget extends StatefulWidget {
  const ParallaxWidget({Key? key}) : super(key: key);

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  final TransformationController _transformationController =
      TransformationController();

  late final Animation<Alignment> parallaxAnimation;
  late final Animation<Offset> originPanAnimation;
  late final Animation<Matrix4> panAnimation;

  late final Animation<Matrix4> centerImageSizeAniamtion;
  late final Animation<Matrix4> centerImageSizeAniamtion2;
  late final Animation<Size> clipperBoxSizeAnimation;

  final List<double> startingPoints = [
    0.0,
  ];

  final clipperBoxKey = GlobalKey();

  RenderBox? clipperRenderBox;

  RenderBox? get getClippingArea {
    if (clipperRenderBox == null) {
      if (clipperBoxKey.currentContext != null) {
        setState(() {
          clipperRenderBox =
              clipperBoxKey.currentContext!.findRenderObject() as RenderBox;

          log(clipperRenderBox!.paintBounds.bottom.toString());
        });
      }
    }

    return clipperRenderBox;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    panAnimation = TweenSequence<Matrix4>([
      TweenSequenceItem(
        tween: Matrix4Tween(
          begin: Matrix4.identity()..scale(1.0, 1.0, 1.0),
          end: Matrix4.identity()..scale(3.0, 3.0, 1.0),
        ),
        weight: 1.0,
      ),
    ]).chain(CurveTween(curve: Curves.linear)).animate(animationController);
    //Start-->New content
    centerImageSizeAniamtion = Tween<Matrix4>(
      begin: Matrix4.identity()..scale(0.0, 0.0, 1.0),
      end: Matrix4.identity()..scale(1.0, 1.0, 1.0),
    ).chain(CurveTween(curve: Curves.linear)).animate(animationController);

    centerImageSizeAniamtion2 = Tween<Matrix4>(
      begin: Matrix4.identity()..scale(0.0, 0.0, 1.0),
      end: Matrix4.identity()..scale(1.0, 1.0, 1.0),
    )
        .chain(CurveTween(
          curve: const Interval(0.3, 1.0, curve: Curves.linear),
        ))
        .animate(animationController);

    clipperBoxSizeAnimation = TweenSequence<Size>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Size(600, 300),
          end: const Size(300, 600),
        ),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Size(300, 600),
          end: const Size(3000, 3000),
        ),
        weight: 1.0,
      ),
    ])
        .chain(
          CurveTween(
            curve: const Interval(
              0.5,
              1.0,
            ),
          ),
        )
        .animate(animationController);

    animationController.addListener(() {
      getClippingArea;
    });

    //---End---

    originPanAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0),
          end: const Offset(0, 0),
        ),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0),
          end: const Offset(100, 0),
        ),
        weight: 1.0,
      ),
    ]).animate(animationController);

    parallaxAnimation = Tween<Alignment>(
      begin: const Alignment(0, 0),
      end: const Alignment(0.5, 0),
    )
        .chain(
          CurveTween(
            curve: const Interval(0.2, 0.5),
          ),
        )
        .animate(
          animationController,
        );

    // animationController.forward();
    // animationController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animationController.forward();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animationController.forward();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                transform: panAnimation.value,
                origin: Offset(MediaQuery.of(context).size.width / 2,
                    MediaQuery.of(context).size.height / 2),
                child: Image.asset(
                  "assets/images/parallax.jpeg",
                  fit: BoxFit.cover,
                  // alignment: parallaxAnimation.value,
                  height: double.maxFinite,
                ),
              ),
              Transform(
                transform: centerImageSizeAniamtion.value,
                origin: Offset(MediaQuery.of(context).size.width / 2,
                    MediaQuery.of(context).size.height / 2),
                child: Image.asset(
                  "assets/images/parallax.jpeg",
                  fit: BoxFit.cover,
                  // alignment: parallaxAnimation.value,
                  height: double.maxFinite,
                ),
              ),
              //  for (var i = 0; i < startingPoints.length; i++)
              // Transform(
              //   transform: Tween<Matrix4>(
              //     begin: Matrix4.identity()..scale(0.0, 0.0, 1.0),
              //     end: Matrix4.identity()..scale(1.0, 1.0, 1.0),
              //   )
              //       .chain(
              //         CurveTween(
              //           curve: Interval(startingPoints[i], 1.0),
              //         ),
              //       )
              //       .animate(animationController)
              //       .value,
              //   origin: Offset(MediaQuery.of(context).size.width / 2,
              //       MediaQuery.of(context).size.height / 2),
              //   child: Image.asset(
              //     "assets/images/parallax.jpeg",
              //     fit: BoxFit.cover,
              //     // alignment: parallaxAnimation.value,
              //     height: double.maxFinite,
              //   ),
              // ),
            ],
          );
          // return ClipPath(
          //   clipper: ImageClipper(
          //     clipperSize: clipperBoxSizeAnimation.value,
          //     clipperRenderBox: getClippingArea,
          //     clipperBoxKey: clipperBoxKey,
          //   ),
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       // Transform(
          //       //   transform: panAnimation.value,
          //       //   origin: Offset(MediaQuery.of(context).size.width / 2,
          //       //       MediaQuery.of(context).size.height / 2),
          //       //   child: Image.asset(
          //       //     "assets/images/parallax.jpeg",
          //       //     fit: BoxFit.cover,
          //       //     // alignment: parallaxAnimation.value,
          //       //     height: double.maxFinite,
          //       //   ),
          //       // ),
          //       // Transform(
          //       //   transform: centerImageSizeAniamtion.value,
          //       //   origin: Offset(MediaQuery.of(context).size.width / 2,
          //       //       MediaQuery.of(context).size.height / 2),
          //       //   child: Image.asset(
          //       //     "assets/images/parallax.jpeg",
          //       //     fit: BoxFit.cover,
          //       //     // alignment: parallaxAnimation.value,
          //       //     height: double.maxFinite,
          //       //   ),
          //       // ),

          //       Image.asset(
          //         "assets/images/parallax.jpeg",
          //         fit: BoxFit.cover,
          //         // alignment: parallaxAnimation.value,
          //         height: double.maxFinite,
          //       ),
          //       Transform.rotate(
          //         angle: math.pi / 4,
          //         child: Container(
          //           height: 300,
          //           width: 300,
          //           key: clipperBoxKey,
          //           color: Colors.red,
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}


// class ImageClipper extends CustomClipper<Path> {
//   ImageClipper({
//     required this.clipperSize,
//     this.clipperRenderBox,
//     required this.clipperBoxKey,
//   });

//   final Size clipperSize;

//   final RenderBox? clipperRenderBox;

//   final GlobalKey clipperBoxKey;

//   @override
//   Path getClip(Size size) {
//     if (clipperRenderBox != null) {
//       final boxSize = clipperRenderBox!.size;

//       log(clipperRenderBox!.localToGlobal(Offset.zero).toString());
//       final boxOffset = clipperBoxKey.globalPaintBounds;

//       final topLeft = rotatedPointOffset(math.pi / 4, boxOffset!.topLeft);
//       final topRight = rotatedPointOffset(math.pi / 4, boxOffset.bottomRight);
//       final bottomLeft = rotatedPointOffset(math.pi / 4, boxOffset.bottomLeft);
//       final bottomRight =
//           rotatedPointOffset(math.pi / 4, boxOffset.bottomRight);

//       final rotatedBottomRight = rotatedPointOffset(math.pi / 4, bottomRight);

//       log(topLeft.toString());
//       final path = Path()
//         ..moveTo(topLeft.dx, topLeft.dy)
//         ..lineTo(topLeft.dx, topLeft.dy)
//         ..lineTo(topRight.dx, topRight.dy)
//         ..lineTo(topRight.dx, topRight.dy)
//         ..lineTo(bottomLeft.dx, bottomLeft.dy);
//       // ..close();

//       return path;
//     }
//     return Path();
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

// extension GlobalKeyExtension on GlobalKey {
//   Rect? get globalPaintBounds {
//     final renderObject = currentContext?.findRenderObject() as RenderBox;
//     final translation = renderObject.getTransformTo(null).getTranslation();
//     if (renderObject.paintBounds != null) {
//       final offset = Offset(translation.x, translation.y);

//       final shiftedRenderBox = renderObject.paintBounds.shift(offset);

//       final rotatedBox = MatrixUtils.transformRect(
//         Matrix4.identity(),
//         shiftedRenderBox,
//       );

//       return rotatedBox;

//       MatrixUtils.transformRect(
//         renderObject.getTransformTo(null)..rotateZ(math.pi / 4),
//         offset & renderObject.size,
//       );
//     } else {
//       return null;
//     }
//   }
// }

// Offset rotatedPointOffset(double angle, Offset pt) {
//   double a = angle;

//   double cosa = math.cos(a);
//   double sina = math.sin(a);

//   final rotatedOffset = Offset(pt.dx * cosa, pt.dx * sina);

//   return rotatedOffset;
// }

// Rect getTransformedCoordinates(GlobalKey boxKey) {
//   final ro = boxKey.currentContext!.findRenderObject() as RenderTransform;
//   /* ro is RenderTransform */
//   final rect = MatrixUtils.transformRect(
//     ro.child!.getTransformTo(ro)..rotateZ(math.pi / 4),
//     Offset.zero & ro.child!.size,
//   );

//   return rect;
// }
