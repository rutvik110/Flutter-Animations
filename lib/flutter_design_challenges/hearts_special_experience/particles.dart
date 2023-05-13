import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animations/flutter_design_challenges/hearts_special_experience/cellular_noise_builder.dart';
import 'package:flutter_animations/flutter_design_challenges/hearts_special_experience/custom_heart.dart';
import 'package:flutter_animations/flutter_design_challenges/hearts_special_experience/load_audio_data.dart';
import 'package:particle_field/particle_field.dart';
import 'package:rnd/rnd.dart';

class HeartsSpecialExperience extends StatelessWidget {
  const HeartsSpecialExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          Positioned.fill(child: CellularNoiseBuilder()),
          ParticlesSystem()
        ],
      ),
    );
  }
}

class ParticlesSystem extends StatefulWidget {
  const ParticlesSystem({super.key});

  @override
  State<ParticlesSystem> createState() => _ParticlesSystemState();
}

class _ParticlesSystemState extends State<ParticlesSystem> {
  double musicAmplitude = 0;
  late Duration maxDuration;
  late Duration elapsedDuration;
  late AudioCache audioPlayer;
  late List<double> samples;
  late int totalSamples;

  late List<String> audioData;

  List<List<String>> audioDataList = [
    [
      'assets/dm.json',
      'dance_monkey.mp3',
    ],
    [
      'assets/soy.json',
      'shape_of_you.mp3',
    ],
    [
      'assets/sp.json',
      'surface_pressure.mp3',
    ],
    [
      'assets/clb.json',
      'clb.mp3',
    ],
  ];

  Future<void> parseData() async {
    final json = await rootBundle.loadString(audioData[0]);
    Map<String, dynamic> audioDataMap = {
      "json": json,
      "totalSamples": totalSamples,
    };
    final samplesData = await compute(loadparseJson, audioDataMap);
    await audioPlayer.load(audioData[1]);
    await audioPlayer.play(audioData[1]);
    // maxDuration in milliseconds
    await Future.delayed(const Duration(milliseconds: 200));

    int maxDurationInmilliseconds =
        await audioPlayer.fixedPlayer!.getDuration();

    maxDuration = Duration(milliseconds: maxDurationInmilliseconds);
    setState(() {
      samples = samplesData["samples"];
    });
  }

  void get updateActiveIndex {
    if (samples.isNotEmpty) {
      final elapsedTimeRatio =
          elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;
      final index = (samples.length * elapsedTimeRatio).round();
      musicAmplitude = index < samples.length ? samples[index] : 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Change this value to number of audio samples you want.
    // Values between 256 and 1024 are good for showing [RectangleWaveform] and [SquigglyWaveform]
    // While the values above them are good for showing [PolygonWaveform]
    totalSamples = 1000;
    audioData = audioDataList[3];
    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );

    samples = [];
    maxDuration = const Duration(milliseconds: 1000);
    elapsedDuration = const Duration();
    parseData();
    audioPlayer.fixedPlayer!.onPlayerCompletion.listen((_) {
      setState(() {
        musicAmplitude = 0;
        elapsedDuration = maxDuration;
      });
    });
    audioPlayer.fixedPlayer!.onAudioPositionChanged
        .listen((Duration timeElapsed) {
      setState(() {
        elapsedDuration = timeElapsed;
        updateActiveIndex;
      });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ParticleField field = ParticleField(
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
        if (particles.length < 300 || isDragging) {
          Future.delayed(const Duration(milliseconds: 300), () {
            particles.add(
              HeartParticle(
                //  sineAngle: 0,
                x: isDragging ? dragPoint.dx : rnd(size.width),
                y: isDragging ? dragPoint.dy : size.height + rnd(size.height),
                vx: 0,
                scale: rnd.getDouble(0.1, 0.3),
                rotation: rnd.getSign(0.5) * degree,
              ),
            );
          });
        }

        // update existing particles:
        for (int i = particles.length - 1; i >= 0; i--) {
          final particle = particles[i] as HeartParticle;
          // call update, which automatically adds vx/vy to x/y
          // add some gravity (ie. increase vertical velocity)
          // and increment the frame
          final sineY = (particle.sineAngle + 1);
          final isCircle = sineY ~/ 2 == 0;
          final updatedSine = isCircle
              ? particle.sineMultipler
              : particle.sineMultipler + 0.0005;
          final displacementx = sin(sineY * degree) * updatedSine;
          final isXAhead = dragPoint.dx < particle.x;
          final isYAhead = dragPoint.dy < particle.y;
          final xChange = isDragging
              ? isXAhead
                  ? -0.01
                  : 0.01
              : 0;
          final yChange = isDragging
              ? isYAhead
                  ? -0.01
                  : 0.01
              : 0;

          final updatedScale = particle.scale + musicAmplitude * 0.01;

          particle.update(
            sineMultipler: updatedSine,
            sineAngle: sineY,
            vx: displacementx + dragVelocity.dx / 100 + xChange,
            vy: particle.vy -
                0.0005 +
                dragVelocity.dy / 100 +
                yChange +
                musicAmplitude * 0.25,
            frame: particle.frame + 1,
            rotation: particle.rotation +
                (displacementx * sin(22.5 * degree) / 10) * particle.scale,
            scale: updatedScale < 0
                ? particle.scale + musicAmplitude.abs() * 0.1
                : updatedScale,
          );

          if (particle.y < -100 ||
              particle.x > (size.width + 100) ||
              particle.x < -100 ||
              particle.y > (size.height * 2)) {
            particles.removeAt(i);
            // (
            //   y: size.height + rnd(size.height),
            //   vy: 0,
            //   sineMultipler: 0,
            //   sineAngle: 0,
            //   vx: displacementx,
            //   x: rnd(size.width) + 0,
            // );
          }
        }
      },
    );

    return GestureDetector(
      onPanUpdate: (drag) {
        dragVelocity = drag.delta;
        dragPoint = drag.localPosition;

        setState(() {});
      },
      onPanStart: (details) {
        isDragging = true;
        setState(() {});
      },
      onPanEnd: (details) {
        dragVelocity = const Offset(0, 0);
        isDragging = false;
        setState(() {});
      },
      child: Stack(
        children: [
          Positioned.fill(child: field),
          Positioned.fill(
            child: CustomEnlightenedHeart(
              musicAmplitude: musicAmplitude,
            ),
          )
        ],
      ),
    );
  }
}

class HeartParticle extends Particle {
  HeartParticle({
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
