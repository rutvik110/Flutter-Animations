import 'dart:convert';
import 'dart:math' as math;

Map<String, dynamic> loadparseJson(Map<String, dynamic> audioDataMap) {
  final data = jsonDecode(audioDataMap["json"]);

  final List<int> rawSamples = List.castFrom<dynamic, int>(data['data']);
  List<int> filteredData = [];
  // Change this value to number of audio samples you want.
  // Values between 256 and 1024 are good for showing [RectangleWaveform] and [SquigglyWaveform]
  // While the values above them are good for showing [PolygonWaveform]
  final int totalSamples = audioDataMap["totalSamples"];
  final double blockSize = rawSamples.length / totalSamples;

  for (int i = 0; i < totalSamples; i++) {
    final double blockStart =
        blockSize * i; // the location of the first sample in the block
    int sum = 0;
    for (int j = 0; j < blockSize; j++) {
      sum = sum +
          rawSamples[(blockStart + j).toInt()]
              .toInt(); // find the sum of all the samples in the block

    }
    filteredData.add((sum / blockSize)
        .round() // take the average of the block and add it to the filtered data
        .toInt()); // divide the sum by the block size to get the average
  }
  final maxNum = filteredData.reduce((a, b) => math.max(a.abs(), b.abs()));

  final double multiplier = math.pow(maxNum, -1).toDouble();

  final samples = filteredData.map<double>((e) => (e * multiplier)).toList();

  return {
    "samples": samples,
  };
}
