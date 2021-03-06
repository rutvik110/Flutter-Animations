import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template hello_world}
/// A Dart Shader class for the `hello_world` shader.
/// {@endtemplate}
class HelloWorld extends UmbraShader {
  HelloWorld._() : super(_cachedProgram!);

  /// {@macro hello_world}
  static Future<HelloWorld> compile() async {
    // Caching the program on the first compile call.
    _cachedProgram ??= await FragmentProgram.compile(
      spirv: Uint8List.fromList(base64Decode(_spirv)).buffer,
    );

    return HelloWorld._();
  }

  static FragmentProgram? _cachedProgram;

  Shader shader({
    required Size resolution,
  }) {
    return program.shader(
      floatUniforms: Float32List.fromList([
        resolution.width,
        resolution.height,
      ]),
      samplerUniforms: [],
    );
  }
}

const _spirv =
    'AwIjBwAAAQAKAA0ALQAAAAAAAAARAAIAAQAAAAsABgABAAAAR0xTTC5zdGQuNDUwAAAAAA4AAwAAAAAAAQAAAA8ABwAEAAAABAAAAG1haW4AAAAAHgAAACYAAAAQAAMABAAAAAgAAAADAAMAAQAAAEABAAAEAAoAR0xfR09PR0xFX2NwcF9zdHlsZV9saW5lX2RpcmVjdGl2ZQAABAAIAEdMX0dPT0dMRV9pbmNsdWRlX2RpcmVjdGl2ZQAFAAQABAAAAG1haW4AAAAABQAHAA0AAABmcmFnbWVudCh2ZjI7dmYyOwAAAAUAAwALAAAAdXYAAAUABQAMAAAAZnJhZ0Nvb3JkAAAABQADABwAAAB1dgAABQAGAB4AAABnbF9GcmFnQ29vcmQAAAAABQAFACIAAAByZXNvbHV0aW9uAAAFAAQAJgAAAF9DT0xPUl8ABQAEACcAAABwYXJhbQAAAAUABAApAAAAcGFyYW0AAABHAAMADQAAAAAAAABHAAMACwAAAAAAAABHAAMADAAAAAAAAABHAAMAEwAAAAAAAABHAAMAFgAAAAAAAABHAAMAGQAAAAAAAABHAAMAHAAAAAAAAABHAAQAHgAAAAsAAAAPAAAARwADACIAAAAAAAAARwAEACIAAAAeAAAAAAAAAEcAAwAjAAAAAAAAAEcAAwAmAAAAAAAAAEcABAAmAAAAHgAAAAAAAABHAAMAJwAAAAAAAABHAAMAKAAAAAAAAABHAAMAKQAAAAAAAABHAAMALAAAAAAAAAATAAIAAgAAACEAAwADAAAAAgAAABYAAwAGAAAAIAAAABcABAAHAAAABgAAAAIAAAAgAAQACAAAAAcAAAAHAAAAFwAEAAkAAAAGAAAABAAAACEABQAKAAAACQAAAAgAAAAIAAAAFQAEAA8AAAAgAAAAAAAAACsABAAPAAAAEAAAAAAAAAAgAAQAEQAAAAcAAAAGAAAAKwAEAA8AAAAUAAAAAQAAACsABAAGAAAAFwAAAAAAAAArAAQABgAAABgAAAAAAIA/IAAEAB0AAAABAAAACQAAADsABAAdAAAAHgAAAAEAAAAgAAQAIQAAAAAAAAAHAAAAOwAEACEAAAAiAAAAAAAAACAABAAlAAAAAwAAAAkAAAA7AAQAJQAAACYAAAADAAAANgAFAAIAAAAEAAAAAAAAAAMAAAD4AAIABQAAADsABAAIAAAAHAAAAAcAAAA7AAQACAAAACcAAAAHAAAAOwAEAAgAAAApAAAABwAAAD0ABAAJAAAAHwAAAB4AAABPAAcABwAAACAAAAAfAAAAHwAAAAAAAAABAAAAPQAEAAcAAAAjAAAAIgAAAIgABQAHAAAAJAAAACAAAAAjAAAAPgADABwAAAAkAAAAPQAEAAcAAAAoAAAAHAAAAD4AAwAnAAAAKAAAAD0ABAAJAAAAKgAAAB4AAABPAAcABwAAACsAAAAqAAAAKgAAAAAAAAABAAAAPgADACkAAAArAAAAOQAGAAkAAAAsAAAADQAAACcAAAApAAAAPgADACYAAAAsAAAA/QABADgAAQA2AAUACQAAAA0AAAAAAAAACgAAADcAAwAIAAAACwAAADcAAwAIAAAADAAAAPgAAgAOAAAAQQAFABEAAAASAAAACwAAABAAAAA9AAQABgAAABMAAAASAAAAQQAFABEAAAAVAAAACwAAABQAAAA9AAQABgAAABYAAAAVAAAAUAAHAAkAAAAZAAAAEwAAABYAAAAXAAAAGAAAAP4AAgAZAAAAOAABAA==';
