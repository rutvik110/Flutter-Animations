import 'dart:developer';

import 'package:flutter/material.dart';

class PiecesScrolling extends StatefulWidget {
  const PiecesScrolling({super.key});

  @override
  State<PiecesScrolling> createState() => _PiecesScrollingState();
}

class _PiecesScrollingState extends State<PiecesScrolling> {
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: ((context, index) {
            return AnimatedBuilder(
                animation: scrollController,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0,
                        0.5,
                        0.5,
                        1,
                      ],
                      colors: [
                        Colors.transparent,
                        Colors.red,
                        Colors.blue,
                        Colors.transparent,
                      ],
                    ),
                    color: Colors.blue,
                  ),
                  child: Image.asset(
                    "assets/images/pokemons/${index + 1}.png",
                    height: 200,
                    width: 200,
                  ),
                ),
                builder: (context, child) {
                  final baseWidth = MediaQuery.of(context).size.width / 2;

                  late double maxScrollWidth;

                  if (scrollController.hasClients &&
                      scrollController.position.haveDimensions) {
                    maxScrollWidth = scrollController.position.maxScrollExtent;
                  } else {
                    final storageContext =
                        scrollController.position.context.storageContext;
                    final double? previousSavedPosition =
                        PageStorage.of(storageContext)
                            ?.readState(storageContext) as double?;
                    if (previousSavedPosition != null) {
                      maxScrollWidth = previousSavedPosition - index.toDouble();
                    } else {
                      maxScrollWidth = scrollController.initialScrollOffset -
                          index.toDouble();
                    }
                  }
                  final individualItemWidth =
                      (maxScrollWidth + baseWidth * 2) / 12;
                  final itemsInView = (baseWidth * 2 / individualItemWidth);
                  final itemOnEdge = (scrollController.offset + baseWidth * 2) /
                      individualItemWidth;
                  final difference = index - (itemOnEdge - itemsInView / 2);
                  final ratio = (itemsInView - difference.abs()) / itemsInView;

                  log(itemOnEdge.toString());
                  log(itemsInView.toString());

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: ratio.abs().clamp(0, 1),
                      child: Transform.scale(
                        scale: ratio,
                        child: child,
                      ),
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }
}
