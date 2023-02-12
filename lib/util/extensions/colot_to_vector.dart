import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vec;

extension GetColorSwatchVector on ColorSwatch<int> {
  vec.Vector3 toColorVector() {
    return vec.Vector3(red / 256, green / 256, blue / 256);
  }
}

extension GetColorVectorForColor on Color {
  vec.Vector3 toColorVector() {
    return vec.Vector3(red / 256, green / 256, blue / 256);
  }
}
