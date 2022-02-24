// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';

// List<double> loadparseJson(String jsonBody) {
//   final data = jsonDecode(jsonBody);
//   final List<int> points = List.castFrom<dynamic, int>(data['data']);
//   List<int> filteredData = [];
//   const int samples = 256;
//   final double blockSize = points.length / samples;

//   for (int i = 0; i < samples; i++) {
//     final double blockStart =
//         blockSize * i; // the location of the first sample in the block
//     int sum = 0;
//     for (int j = 0; j < blockSize; j++) {
//       sum = sum +
//           points[(blockStart + j).toInt()]
//               .abs(); // find the sum of all the samples in the block
//       //.toabs(); will create waves with only positive values
//       //toInt() will convert the double to an int with positive/negative values

//     }
//     filteredData.add((sum / blockSize)
//         .round() // take the average of the block and add it to the filtered data
//         .toInt()); // divide the sum by the block size to get the average
//   }
//   final maxNum = filteredData.reduce(math.max);

//   final double multiplier = math.pow(maxNum, -1).toDouble();

//   filteredData.add(0);
//   log('filteredData: $filteredData');
//   print(filteredData);
//   return filteredData.map<double>((e) => (e * multiplier)).toList();
// }

// class AudioVisualizer extends StatefulWidget {
//   const AudioVisualizer({Key? key}) : super(key: key);

//   @override
//   State<AudioVisualizer> createState() => _AudioVisualizerState();
// }

// class _AudioVisualizerState extends State<AudioVisualizer> {
//   late List<double> data;
//   late AudioCache audioPlayer;

//   double sliderValue = 0;
//   int maxDuration = 1;
//   int xAudio = 0;

//   Future<void> parseData() async {
//     final jsonString = await rootBundle.loadString('assets/soy.json');
//     final dataPoints = await compute(loadparseJson, jsonString);
//     await audioPlayer.load('/dance_monkey.mp3');
//     await audioPlayer.play('/dance_monkey.mp3');
//     maxDuration = await audioPlayer.fixedPlayer!.getDuration();
//     log(dataPoints.length.toString());
//     setState(() {
//       data = dataPoints;
//       print(data);
//     });
//     log(data.toString());
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     audioPlayer = AudioCache(
//       fixedPlayer: AudioPlayer(),
//     );
//     data = [];
//     parseData();
//     audioPlayer.fixedPlayer!.onPlayerStateChanged.listen((state) {
//       if (state == PlayerState.COMPLETED) {
//         setState(() {
//           sliderValue = 1;
//           audioPlayer.play('/shape_of_you.mp3');

//           ///Fix for incomplettion on audio complete
//           //  audioPlayer.fixedPlayer!.seek(Duration(milliseconds: (maxDuration)));
//         });
//       }
//     });
//     audioPlayer.fixedPlayer!.onAudioPositionChanged.listen((Duration p) {
//       setState(() {
//         if (p.inMilliseconds == 0) {
//           sliderValue = 0;

//           xAudio = (data.length * sliderValue).toInt();
//         } else {
//           sliderValue = double.parse(
//               ((p.inMilliseconds) / maxDuration).toStringAsFixed(20));

//           xAudio = (data.length * sliderValue).toInt();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFb1cad5),
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text('Audio Visualizer'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // AnimatedContainer(
//           //   duration: Duration(milliseconds: 100),
//           //   height: data[xAudio] * 250 < 0
//           //       ? -data[xAudio] * 250
//           //       : data[xAudio] * 250,
//           //   width: data[xAudio] * 250 < 0
//           //       ? -data[xAudio] * 250
//           //       : data[xAudio] * 250,
//           //   decoration: BoxDecoration(
//           //       color: Colors.blue,
//           //       borderRadius: BorderRadius.circular(data[xAudio] * 250 < 0
//           //           ? -data[xAudio] * 250 / 2
//           //           : data[xAudio] * 250 / 2)),
//           // ),
//           if (data.isNotEmpty)
//             Stack(
//               children: [
//                 CustomPaint(
//                   size: Size(MediaQuery.of(context).size.width,
//                       MediaQuery.of(context).size.height * 0.2),
//                   painter: AudioVisualizerPainter(
//                       samples: data, sliderValue: xAudio),
//                 ),
//                 CustomPaint(
//                   size: const Size(400, 100),
//                   painter:
//                       ActiveTrackPainter(samples: data, sliderValue: xAudio),
//                 ),
//               ],
//             ),
//           // Slider(
//           //   value: sliderValue.toDouble(),
//           //   min: 0,
//           //   activeColor: Colors.red,
//           //   max: 1,
//           //   onChanged: (val) {
//           //     setState(() {
//           //       sliderValue = val;
//           //       audioPlayer.fixedPlayer!.seek(Duration(
//           //           milliseconds: (maxDuration * sliderValue).toInt()));
//           //     });
//           //   },
//           // ),

//           if (data.isNotEmpty)
//             Transform(
//               transform: Matrix4.rotationX(180),
//               origin: const Offset(0, 62),
//               child: Column(
//                 children: const [
//                   // Stack(
//                   //   children: [
//                   //     CustomPaint(
//                   //       size: Size(MediaQuery.of(context).size.width, 100),
//                   //       painter: AudioVisualizerPainter(
//                   //           samples: data, sliderValue: xAudio),
//                   //     ),
//                   //     CustomPaint(
//                   //       size: Size(MediaQuery.of(context).size.width, 100),
//                   //       painter: ActiveTrackPainter(
//                   //           samples: data, sliderValue: xAudio),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           if (data.isNotEmpty)
//             Stack(
//               children: [
//                 CustomPaint(
//                   size: Size(MediaQuery.of(context).size.width, 35),
//                   painter: AudioVisualizerPainter(
//                       samples: data, sliderValue: xAudio),
//                 ),
//                 CustomPaint(
//                   size: Size(MediaQuery.of(context).size.width, 35),
//                   painter:
//                       ActiveTrackPainter(samples: data, sliderValue: xAudio),
//                 ),
//               ],
//             ),
//           Slider(
//             value: sliderValue.clamp(0, 1),
//             min: 0,
//             activeColor: Colors.red,
//             max: 1,
//             onChanged: (val) {
//               log(val.toString());
//               setState(() {
//                 sliderValue = val;
//                 audioPlayer.fixedPlayer!.seek(Duration(
//                     milliseconds: (maxDuration * sliderValue).toInt()));
//               });
//             },
//           ),

//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: [

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               RaisedButton(
//                 child: const Text('Play'),
//                 onPressed: () async {
//                   await audioPlayer.play("/dance_monkey.mp3");
//                 },
//               ),
//               // SizedBox(
//               //   width: 20,
//               // ),
//               // //     RaisedButton(
//               // //       child: Text('Pause'),
//               // //       onPressed: () {
//               // //         audioPlayer.fixedPlayer!.pause();
//               // //       },
//               // //     ),
//               RaisedButton(
//                 child: const Text('Stop'),
//                 onPressed: () {
//                   audioPlayer.fixedPlayer!.stop();
//                 },
//               ),
//             ],
//           ),
//           //     RaisedButton(
//           //       child: Text('Stop'),
//           //       onPressed: () {
//           //         audioPlayer.fixedPlayer!.stop();
//           //       },
//           //     ),
//           //   ],
//           // ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class ActiveTrackPainter extends CustomPainter {
//   ActiveTrackPainter({
//     required this.samples,
//     required this.sliderValue,
//   });
//   final List<double> samples;
//   final int sliderValue;
//   @override
//   void paint(Canvas canvas, Size size) {
//     final activeTrackPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1
//       ..shader = const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           // transform: GradientRotation(math.pi / 2),
//           colors: [
//             Color(0xFFff3400),
//             Color(0xFFff6d00),
//             // Color(0xFFFFB5A0),
//           ],
//           stops: [
//             0,
//             1,
//           ]).createShader(
//         Rect.fromLTWH(0, 0, size.width, size.height),
//       );
//     // ..color = Colors.red.withOpacity(0.5);
//     final activePaint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 5.0
//       ..color = Colors.red;
//     final path = Path();

//     final double ax = (size.width / samples.length) * sliderValue;
//     final double ay = samples[sliderValue] * size.height;

//     path.moveTo(0, size.height);
//     path.lineTo(0, size.height);
//     path.lineTo(0, -size.height);
//     path.lineTo(ax, -size.height);
//     path.lineTo(ax, size.height);
//     path.close();
//     //canvas.drawPath(path, activeTrackPaint);
//     canvas.drawCircle(Offset(ax, ay), 10, activePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class AudioVisualizerPainter extends CustomPainter {
//   AudioVisualizerPainter({
//     required this.samples,
//     required this.sliderValue,
//   });
//   final List<double> samples;
//   final int sliderValue;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1.0
//       // ..color = Color(0xFFff3400);
//       ..shader = const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           // transform: GradientRotation(math.pi / 2),
//           colors: [
//             Colors.white,
//             Colors.white,
//             // Color(0xFFff3400),
//             // Color(0xFFff6d00),
//             // Color(0xFFFFB5A0),
//           ],
//           stops: [
//             0,
//             1,
//           ]).createShader(
//         Rect.fromLTWH(0, 0, size.width, size.height),
//       );
//     final strokePaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = const Color(0xFFb1cad5)
//       ..strokeWidth = 0.2;

//     ///for bouncycircleswithanimatingradius
//     //  final double ay = samples[sliderValue] * size.height;

//     List<Offset> offsets = [];
//     final double width = size.width / samples.length;

//     for (var i = 0; i < samples.length; i++) {
//       final double x = i == samples.length - 1 ? size.width : width * i;
//       final double y = samples[i] * size.height;
//       // final double x2 =
//       //     i + 1 == samples.length ? width * (i * 2) : width * (i + 1);
//       // final double y2 = i + 1 == samples.length
//       //     ? samples[i] * size.height
//       //     : samples[i + 1] * size.height;
//       offsets.add(Offset(x, y));
//       //bouncycircleswithanimatingradius
//       final double radius =
//           ((y * 1) * ay / 2) < 0 ? -((y * 1) * ay / 2) : ((y * 1) * ay / 2);
//       //canvas.drawCircle(Offset(size.width / 2, 0), radius / 10, paint);
//       //rectangles like soundcloud
//       // canvas.drawRect(Rect.fromLTRB(x, 0, x2, y2 == 0 ? 1 : y2), paint);
//       // canvas.drawRect(Rect.fromLTRB(x, 0, x2, y2 == 0 ? 1 : y2), strokePaint);

//       //curve

//     }

//     canvas.drawPoints(PointMode.polygon, offsets, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     return true;
//   }
// }
