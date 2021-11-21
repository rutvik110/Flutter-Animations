import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

List<double> loadparseJson(String jsonBody) {
  final data = jsonDecode(jsonBody);
  final List<int> points = List.castFrom<dynamic, int>(data['data']);
  List<int> filteredData = [];
  const int samples = 256;
  final double blockSize = points.length / samples;

  for (int i = 0; i < samples; i++) {
    final double blockStart =
        blockSize * i; // the location of the first sample in the block
    int sum = 0;
    for (int j = 0; j < blockSize; j++) {
      sum = sum +
          points[(blockStart + j)
              .toInt()]; // find the sum of all the samples in the block
    }
    filteredData.add((sum / blockSize)
        .round() // take the average of the block and add it to the filtered data
        .toInt()); // divide the sum by the block size to get the average
  }
  final maxNum = filteredData.reduce(math.max);

  final double multiplier = math.pow(maxNum, -1).toDouble();

  filteredData.add(0);
  log('filteredData: $filteredData');
  return filteredData.map<double>((e) => (e * multiplier)).toList();
}

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({Key? key}) : super(key: key);

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  late List<double> data;
  late AudioCache audioPlayer;

  double sliderValue = 0;
  int maxDuration = 1;
  int xAudio = 0;

  Future<void> parseData() async {
    final jsonString = await rootBundle.loadString('assets/audio_data.json');
    final dataPoints = await compute(loadparseJson, jsonString);
    await audioPlayer.load('/audio.mp3');
    await audioPlayer.play('/audio.mp3');
    maxDuration = await audioPlayer.fixedPlayer!.getDuration();

    setState(() {
      data = dataPoints;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );
    data = [];
    parseData();
    audioPlayer.fixedPlayer!.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        sliderValue =
            double.parse((p.inMilliseconds / maxDuration).toStringAsFixed(20));

        xAudio = ((data.length - 1) * sliderValue).toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Audio Visualizer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: data[xAudio] * 250 < 0
                ? -data[xAudio] * 250
                : data[xAudio] * 250,
            width: data[xAudio] * 250 < 0
                ? -data[xAudio] * 250
                : data[xAudio] * 250,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(data[xAudio] * 250 < 0
                    ? -data[xAudio] * 250 / 2
                    : data[xAudio] * 250 / 2)),
          ),
          // Stack(
          //   children: [
          //     CustomPaint(
          //       size: const Size(400, 100),
          //       painter:
          //           AudioVisualizerPainter(samples: data, sliderValue: xAudio),
          //     ),
          //     //     // CustomPaint(
          //     //     //   size: const Size(400, 100),
          //     //     //   painter: ActiveTrackPainter(samples: data, sliderValue: xAudio),
          //     //     // ),
          //   ],
          // ),
          // Slider(
          //   value: sliderValue.toDouble(),
          //   min: 0,
          //   activeColor: Colors.red,
          //   max: 1,
          //   onChanged: (val) {
          //     setState(() {
          //       sliderValue = val;
          //       audioPlayer.fixedPlayer!.seek(Duration(
          //           milliseconds: (maxDuration * sliderValue).toInt()));
          //     });
          //   },
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Play'),
                onPressed: () async {
                  await audioPlayer.play("/audio.mp3");
                },
              ),
              // SizedBox(
              //   width: 20,
              // ),
              // //     RaisedButton(
              // //       child: Text('Pause'),
              // //       onPressed: () {
              // //         audioPlayer.fixedPlayer!.pause();
              // //       },
              // //     ),
              RaisedButton(
                child: Text('Stop'),
                onPressed: () {
                  audioPlayer.fixedPlayer!.stop();
                },
              ),
            ],
          ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class ActiveTrackPainter extends CustomPainter {
  ActiveTrackPainter({
    required this.samples,
    required this.sliderValue,
  });
  final List<double> samples;
  final int sliderValue;
  @override
  void paint(Canvas canvas, Size size) {
    final activeTrackPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10.0
      ..color = Colors.red.withOpacity(0.5);
    final activePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0
      ..color = Colors.red;
    final path = Path();

    final double ax = (size.width / samples.length) * sliderValue;
    final double ay = samples[sliderValue] * size.height;

    path.moveTo(0, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, -size.height);
    path.lineTo(ax, -size.height);
    path.lineTo(ax, size.height);
    path.close();
    //canvas.drawPath(path, activeTrackPaint);
    //canvas.drawCircle(Offset(ax, ay), 10, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AudioVisualizerPainter extends CustomPainter {
  AudioVisualizerPainter({
    required this.samples,
    required this.sliderValue,
  });
  final List<double> samples;
  final int sliderValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: GradientRotation(math.pi / 2),
          colors: [
            Colors.blueAccent[700]!,
            Colors.red,
          ],
          stops: [
            0.3,
            0.5,
          ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final double ay = samples[sliderValue] * size.height;

    List<Offset> offsets = [];
    for (var i = 0; i < samples.length; i++) {
      final double width = size.width / samples.length;
      final double x = width * i;
      final double y = samples[i] * size.height;
      final double x2 = i + 1 == samples.length ? width * i : width * (i + 1);
      final double y2 = i + 1 == samples.length
          ? samples[i] * size.height
          : samples[i + 1] * size.height;
      offsets.add(Offset(x, y));
      //bouncycircleswithanimatingradius
      final double radius =
          ((y * 1) * ay / 2) < 0 ? -((y * 1) * ay / 2) : ((y * 1) * ay / 2);
      canvas.drawCircle(Offset(size.width / 2, 0), radius, paint);
      //rectangles like soundcloud
      //  canvas.drawRect(Rect.fromLTRB(x, y, x2, y2), paint);
      //curve

    }

    //canvas.drawPoints(PointMode.polygon, offsets, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
