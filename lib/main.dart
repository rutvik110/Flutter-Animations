import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_design_challenges/audio_visualizer/audio_visualizer.dart';
import 'package:flutter_animations/flutter_design_challenges/parallax_effect/parallax_effect.dart';
import 'package:flutter_animations/flutter_design_challenges/spotify_album_view/spotify_album_view.dart';
import 'package:flutter_animations/flutter_design_challenges/star_wars_intro_theme/star_wars_intro.dart';
import 'package:flutter_animations/flutter_render_objects/custom_render_objects.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
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
          textTheme: GoogleFonts.gothicA1TextTheme(
            Theme.of(context).textTheme,
          )),
      home: const StarWardsIntro(),
    );
  }
}
