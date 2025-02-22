import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

import 'particle_system.dart';

class SmokeSimulation extends StatefulWidget {
  const SmokeSimulation({super.key});

  @override
  State<SmokeSimulation> createState() => _SmokeSimulationState();
}

class _SmokeSimulationState extends State<SmokeSimulation> {
  late ParticleSystem ps;
  late PImage img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Processing(
        sketch: Sketch.simple(
          setup: (sketch) async {
            sketch.size(width: 400, height: 360);
            img = await sketch.loadImage("assets/images/texture.png");
            ps = ParticleSystem(20, PVector(sketch.width / 2, sketch.height - 60), img);
          },
          draw: (sketch) {
            sketch.background(color: Colors.black);

            // sketch.image(image: img, origin: Offset(sketch.width / 2, sketch.height - 60));

            // Calculate a "wind" force based on mouse horizontal position
            double dx = sketch.map(sketch.mouseX, 0, sketch.width, -0.2, 0.2).toDouble();
            PVector wind = PVector(dx, 0);
            ps.applyForce(wind);
            ps.run(sketch);
            for (int i = 0; i < 2; i++) {
              ps.addParticle();
            }
          },
        ),
      ),
    );
  }
}
