import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/hearts_special_experience/cellular_noise_builder.dart';
import 'package:particle_field/particle_field.dart';
import 'package:rnd/rnd.dart';

class FishesUnderwater extends StatefulWidget {
  const FishesUnderwater({super.key});

  @override
  State<FishesUnderwater> createState() => _FishesUnderwaterState();
}

class _FishesUnderwaterState extends State<FishesUnderwater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: const [
          Expanded(
            child: HeartsSpecialExperience2(),
          ),
        ],
      ),
    );
  }
}

class HeartsSpecialExperience2 extends StatelessWidget {
  const HeartsSpecialExperience2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: const [
          Positioned.fill(child: CellularNoiseBuilder()),
          Positioned.fill(child: ParticlesSystem2())
        ],
      ),
    );
  }
}

class ParticlesSystem2 extends StatefulWidget {
  const ParticlesSystem2({super.key});

  @override
  State<ParticlesSystem2> createState() => _ParticlesSystemState();
}

class _ParticlesSystemState extends State<ParticlesSystem2>
    with SingleTickerProviderStateMixin {
  double musicAmplitude = 0;
  late Duration maxDuration;
  late Duration elapsedDuration;
  late AudioCache audioPlayer;
  late List<double> samples;
  late int totalSamples;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Change this value to number of audio samples you want.
    // Values between 256 and 1024 are good for showing [RectangleWaveform] and [SquigglyWaveform]
    // While the values above them are good for showing [PolygonWaveform]
    totalSamples = 1000;
    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await audioPlayer.load("power_up.mp3");
    });

    samples = [];
    maxDuration = const Duration(milliseconds: 1000);
    elapsedDuration = const Duration();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    animationController.addListener(() {
      if (animationController.status == AnimationStatus.reverse) {
        audioPlayer.fixedPlayer!.setVolume(animationController.value);
      }

      if (animationController.status == AnimationStatus.forward) {
        audioPlayer.fixedPlayer!.setVolume(animationController.value);
      }

      if (animationController.status == AnimationStatus.completed) {
        if (dragVelocity == Offset.zero) {
          audioPlayer.fixedPlayer!.stop();
        }
      }
    });

    audioPlayer.fixedPlayer!.onPlayerCompletion.listen((event) {
      if (animationController.status == AnimationStatus.forward) {
        audioPlayer.fixedPlayer!.seek(Duration.zero);
        audioPlayer.fixedPlayer!.resume();
      }
    });
  }

  final degree = (pi / 180);
  Offset dragVelocity = const Offset(0, 0);
  Offset dragPoint = const Offset(0, 0);

  bool isDragging = false;

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.fixedPlayer!.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ParticleField dragfield = ParticleField(
      spriteSheet: SpriteSheet(
        image: Image.asset(
          'assets/images/heart.png',
        ).image,
      ),
      // top left will be 0,0:
      origin: Alignment.topLeft,

      // onTick is where all the magic happens:
      onTick: (controller, elapsed, size) {
        List<Particle> particles = controller.particles;
        // add a new particle each frame:
        if (isDragging) {
          Future.delayed(const Duration(milliseconds: 300), () {
            particles.add(
              HeartParticle2(
                //  sineAngle: 0,
                x: rnd(size.width),
                y: rnd(size.height),
                vx: 0,
                scale: rnd.getDouble(0.1, 0.3),
                rotation: rnd.getSign(0.5) * degree,
              ),
            );
          });
        }

        for (int i = particles.length - 1; i >= 0; i--) {
          final particle = particles[i] as HeartParticle2;

          // Calculate the vector between the particle and the drag point
          final particleToDrag =
              Offset(dragPoint.dx - particle.x, dragPoint.dy - particle.y);

          // Calculate the distance between the particle and the drag point
          final distance = particleToDrag.distance;

          // Set the maximum distance the particle can move per frame
          const maxDistance = 10.0;

          if (distance < maxDistance) {
            // If the particle is within range of the drag point, move it towards the point
            particle.x += particleToDrag.dx;
            particle.y += particleToDrag.dy;
          } else {
            // If the particle is too far away from the drag point, move it towards the point with a maximum distance limit
            particle.x += particleToDrag.dx * maxDistance / distance;
            particle.y += particleToDrag.dy * maxDistance / distance;
          }

          // Add some gravity (ie. increase vertical velocity)
          particle.vy += 0.1;

          // Increment the frame
          particle.frame++;

          // Remove particles that are outside the screen bounds
          if (particle.y < -100 ||
              particle.x > (size.width + 100) ||
              particle.x < -100 ||
              particle.y > (size.height * 2)) {
            if (particles.length > 1) {
              particles.removeAt(i);
            }
          }
          // check if particle is within a radius of dragpoint of 10, if its reduce its size
          if (distance < 10) {
            particle.update(
              scale: particle.scale -= 0.01,
            );
            if (particle.scale < 0) {
              particles.removeAt(i);
            }
          }
        }
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        MouseRegion(
          cursor: isDragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          onHover: (details) {
            dragPoint = details.localPosition;
            setState(() {});
          },
          child: GestureDetector(
            onTapDown: (details) async {
              audioPlayer.fixedPlayer!.seek(Duration.zero);

              audioPlayer.play("power_up.mp3");
              animationController.forward();
              if (animationController.isCompleted) {
                animationController.reset();
                animationController.forward();
              }
            },
            onPanStart: (d) {
              isDragging = true;
              setState(() {});
              if (audioPlayer.fixedPlayer!.state != PlayerState.PLAYING) {
                audioPlayer.fixedPlayer!.seek(Duration.zero);

                audioPlayer.play("power_up.mp3");
              }
            },
            onPanUpdate: (details) {
              dragVelocity = details.delta;
              dragPoint = details.localPosition;

              dragVelocity = details.delta;
              dragPoint = details.localPosition;
              setState(() {});
            },
            onPanEnd: (d) async {
              dragVelocity = const Offset(0, 0);
              isDragging = false;
              setState(() {});
              animationController.reverse();
            },
            onTapUp: (details) async {
              Timer(const Duration(milliseconds: 300), () {
                dragVelocity = const Offset(0, 0);
                isDragging = false;
                setState(() {});
                animationController.reverse();
              });
            },
            child: AnimatedBuilder(
                animation: animationController,
                builder: (context, _) {
                  return AnimeWarpBuilder(
                    dragPoint: dragPoint,
                    noiseStretchFactor: animationController.value,
                    child: const ColoredBox(
                      color: Colors.black,
                    ),
                  );
                }),
          ),
        ),
        IgnorePointer(
          child: Positioned.fill(child: dragfield),
        ),
      ],
    );
  }
}

class HeartParticle2 extends Particle {
  HeartParticle2({
    this.sineAngle = 0,
    this.sineMultipler = 0,
    super.x = 0.0,
    super.y = 0.0,
    super.scale = 1.0,
    super.rotation = 0.0,
    super.frame = 0,
    super.color = Colors.black,
    super.vx = 0.0,
    super.vy = 0.0,
    super.lifespan = 0.0,
    super.age = 0.0,
  });

  double sineAngle;
  double sineMultipler;

  @override
  void update({
    double? sineAngle,
    double? sineMultipler,
    double? x,
    double? y,
    double? scale,
    double? rotation,
    int? frame,
    Color? color,
    double? vx,
    double? vy,
    double? lifespan,
    double? age,
  }) {
    // TODO: implement update
    if (sineAngle != null) {
      this.sineAngle = sineAngle;
    }
    if (sineMultipler != null) {
      this.sineMultipler = sineMultipler;
    }
    super.update(
      x: x,
      y: y,
      scale: scale,
      rotation: rotation,
      frame: frame,
      color: color,
      vx: vx,
      vy: vy,
      lifespan: lifespan,
      age: age,
    );
  }
}
