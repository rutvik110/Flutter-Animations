import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_shaders/checking_out/hello_world.dart';

class CheckingOut extends StatefulWidget {
  const CheckingOut({Key? key}) : super(key: key);

  @override
  State<CheckingOut> createState() => _CheckingOutState();
}

class _CheckingOutState extends State<CheckingOut> {
  late Future<HelloWorld> helloWorld;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = HelloWorld.compile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checking Out'),
      ),
      body: Center(
        child: FutureBuilder<HelloWorld>(
          future: helloWorld,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ShaderMask(
                shaderCallback: ((bounds) {
                  return snapshot.data!.shader(
                    resolution: Size(
                      bounds.size.width,
                      bounds.size.height,
                    ),
                  );
                }),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
