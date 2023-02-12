import 'dart:ui';

import 'package:flutter/foundation.dart';

extension toUniforms on FragmentShader {
  FragmentShader shader({
    required Float32List floatUniforms,
    List<Image> samplerUniforms = const [],
  }) {
    for (var i = 0; i < floatUniforms.length; i++) {
      setFloat(i, floatUniforms[i]);
    }
    for (var i = 0; i < samplerUniforms.length; i++) {
      setImageSampler(i, samplerUniforms[i]);
    }

    return this;
  }
}
