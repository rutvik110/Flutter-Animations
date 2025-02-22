import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_shaders/stripes_shader/stripes_shader_builder.dart';
import 'package:vector_math/vector_math.dart' as vec;

class PicturesStack extends StatefulWidget {
  const PicturesStack({Key? key}) : super(key: key);

  @override
  State<PicturesStack> createState() => _ImagesStackerState();
}

class _ImagesStackerState extends State<PicturesStack> {
  final key = GlobalKey<AnimatedListState>();

  List<Pokemon> items = [
    Pokemon(
      assetImage: "assets/images/pokemons/5.png",
      color1: Colors.red.toColorVector(),
      color2: Colors.blue.toColorVector(),
    ),
    Pokemon(
      assetImage: "assets/images/pokemons/1.png",
      color1: Colors.green.toColorVector(),
      color2: Colors.yellow.toColorVector(),
    ),
    Pokemon(
      assetImage: "assets/images/pokemons/2.png",
      color1: Colors.orange.toColorVector(),
      color2: Colors.pink.toColorVector(),
    ),
    Pokemon(
      assetImage: "assets/images/pokemons/3.png",
      color1: Colors.purple.toColorVector(),
      color2: Colors.pink.toColorVector(),
    ),
    Pokemon(
      assetImage: "assets/images/pokemons/4.png",
      color1: Colors.cyan.toColorVector(),
      color2: Colors.lightBlue.toColorVector(),
    ),
  ];
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
        centerTitle: false,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Build your team",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Container(
            decoration: const BoxDecoration(
                // color: Colors.black,
                ),
            child: SizedBox(
              height: 400,
              child: AnimatedList(
                  key: key,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  initialItemCount: items.length,
                  itemBuilder: (context, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Align(
                          widthFactor: math.max(animation.value, 0.0),
                          child: SlideTransition(
                            position: animation.drive(CurveTween(curve: Curves.decelerate)).drive(
                                  Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ),
                                ),
                            child: RotationTransition(
                              turns: animation.drive(
                                Tween<double>(
                                  begin: (math.pi / 180) * 22.5,
                                  end: 0,
                                ),
                              ),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Align(
                        widthFactor: 0.7,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(140),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(199, 141, 141, 141),
                                blurRadius: 20,
                                spreadRadius: 0.1,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            key: items[index].key,
                            child: Stack(
                              children: [
                                StripesShaderBuilder(
                                  updateShaderInputs: (shader, size, delta) {
                                    return StripesShaderArguments(
                                      size: size,
                                      delta: delta,
                                      tiles: 2,
                                      speed: delta / 10,
                                      direction: 0.1,
                                      warpScale: 0.3,
                                      warpTiling: 0.25,
                                      color1: items[index].color1,
                                      color2: items[index].color2,
                                    );
                                  },
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                      // image: DecorationImage(
                                      //   image: AssetImage(
                                      //     items[index].assetImage,
                                      //   ),
                                      // ),
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                        70,
                                      ),
                                    ),
                                    child: const SizedBox(
                                      height: 140,
                                      width: 140,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                    items[index].assetImage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  final index = math.Random().nextInt(items.length < 5 ? items.length : 4) + 1;
                  final item = pokemonstList[index];
                  setState(() {
                    items.insert(
                      index,
                      item,
                    );
                    key.currentState?.insertItem(
                      index,
                    );
                    final double jumpOffset = index * 70;
                    if (scrollController.position.maxScrollExtent > 0) {
                      scrollController.animateTo(
                        jumpOffset,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                      );
                    }
                  });
                },
                child: const Text("Add"),
              ),
              const SizedBox(
                width: 70,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final index = math.Random().nextInt(items.length - 1);
                    final removedItem = items.removeAt(index);
                    key.currentState?.removeItem(
                      index,
                      duration: const Duration(milliseconds: 300),
                      (context, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Align(
                              widthFactor: math.max(animation.value, 0.0),
                              child: SlideTransition(
                                position: animation.drive(
                                  Tween<Offset>(
                                    begin: const Offset(0, -1),
                                    end: Offset.zero,
                                  ),
                                ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: Align(
                            widthFactor: 0.7,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(140),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(202, 234, 234, 234),
                                    blurRadius: 20,
                                    spreadRadius: 0.1,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                key: removedItem.key,
                                child: Stack(
                                  children: [
                                    StripesShaderBuilder(
                                      direction: 1.0,
                                      updateShaderInputs: (shader, size, delta) {
                                        return StripesShaderArguments(
                                          size: size,
                                          delta: delta,
                                          tiles: 4,
                                          speed: delta / 10,
                                          direction: 0.85,
                                          warpScale: 1.0,
                                          warpTiling: 0.6,
                                          color1: removedItem.color1,
                                          color2: removedItem.color2,
                                        );
                                      },
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 30,
                                            color: Colors.white,
                                          ),
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //     items[index].assetImage,
                                          //   ),
                                          // ),
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            70,
                                          ),
                                        ),
                                        child: const SizedBox(
                                          height: 140,
                                          width: 140,
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                        removedItem.assetImage,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    final double jumpOffset = index * 70;

                    if (scrollController.position.maxScrollExtent > 0) {
                      scrollController.animateTo(
                        jumpOffset,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                      );
                    }
                  });
                },
                child: const Text("Remove"),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Pokemon {
  Pokemon({
    required this.assetImage,
    required this.color1,
    required this.color2,
  });
  final String assetImage;
  final vec.Vector3 color1;
  final vec.Vector3 color2;
  final UniqueKey key = UniqueKey();
}

extension GetColorVector on ColorSwatch<int> {
  vec.Vector3 toColorVector() {
    return vec.Vector3(red / 256, green / 256, blue / 256);
  }
}

List<Pokemon> pokemonstList = List.unmodifiable([
  Pokemon(
    assetImage: "assets/images/pokemons/5.png",
    color1: Colors.red.toColorVector(),
    color2: Colors.blue.toColorVector(),
  ),
  Pokemon(
    assetImage: "assets/images/pokemons/1.png",
    color1: Colors.green.toColorVector(),
    color2: Colors.yellow.toColorVector(),
  ),
  Pokemon(
    assetImage: "assets/images/pokemons/2.png",
    color1: Colors.orange.toColorVector(),
    color2: Colors.pink.toColorVector(),
  ),
  Pokemon(
    assetImage: "assets/images/pokemons/3.png",
    color1: Colors.purple.toColorVector(),
    color2: Colors.pink.toColorVector(),
  ),
  Pokemon(
    assetImage: "assets/images/pokemons/4.png",
    color1: Colors.cyan.toColorVector(),
    color2: Colors.lightBlue.toColorVector(),
  ),
]);
