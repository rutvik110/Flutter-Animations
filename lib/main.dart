import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_gestures/continous_drag_selection/continous_drag_selection.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes_shader_view.dart';
import 'package:flutter_animations/maths_meet_flutter/fire_simulations/smoke_simulation.dart';

import 'maths_meet_flutter/wave_function_collapse.dart';

late ui.Image image;

List<ui.Image> tilesImages = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final imageBytes = await rootBundle.load("assets/images/texture.png");

  image = await decodeImageFromList(imageBytes.buffer.asUint8List());

  for (var value in Direction.values) {
    final bytes = await rootBundle.load("assets/images/wfc_tiles/${value.name.toLowerCase()}.png");
    final image = await decodeImageFromList(bytes.buffer.asUint8List());
    tilesImages.add(image);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Animations',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF0e7cfe),
          primarySwatch: Colors.blue,
          // textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
        ),
        home: const WaveFunctionCollapseView()
        //     Scaffold(
        //   backgroundColor: Colors.black,
        //   body: Center(
        //     child: CustomPaint(
        //       painter: ImagePainter(),
        //       size: const Size(200, 200),
        //     ),
        //   ),
        // ),
        );
  }
}

// painter that draw image
class ImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..colorFilter = const ColorFilter.mode(
        Color.fromARGB(255, 255, 255, 255),
        BlendMode.srcIn,
      );

    // add tint to the image

    canvas
      ..save()
      // ..translate(-size.width / 2, -size.height / 2)
      ..drawImage(
        image,
        Offset.zero,
        paint,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ShaderStripesDemo extends StatelessWidget {
  const ShaderStripesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
