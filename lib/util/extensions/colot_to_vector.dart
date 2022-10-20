import 'package:flutter/material.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

extension GetColorVector on ColorSwatch<int> {
  Vector3 toColorVector() {
    return Vector3(red / 256, green / 256, blue / 256);
  }
}
