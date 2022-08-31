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
                child: CircleAvatar(
                  radius: 30,
                  child: Image.asset(
                    "assets/images/pokemons/${index + 1}.png",
                  ),
                ),
                builder: (context, child) {
                  final baseWidth = MediaQuery.of(context).size.width / 2;
                  final maxScrollWidth =
                      scrollController.position.maxScrollExtent;
                  final individualItemWidth =
                      (maxScrollWidth + baseWidth * 2) / 12;
                  final itemsInView = baseWidth * 2 / individualItemWidth;
                  final itemOnEdge = (scrollController.offset + baseWidth * 2) /
                      individualItemWidth;
                  final difference = index - (itemOnEdge - itemsInView / 2);
                  final ratio = (itemsInView - difference.abs()) / itemsInView;
                  final numerator = (itemsInView.round() - itemOnEdge - index) *
                      individualItemWidth;
                  final denominator = baseWidth;
                  final widthRatio = numerator / denominator;
                  log(itemsInView.toString());
                  log(itemOnEdge.toString());
                  // log(index.toString());

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                      scale: ratio,
                      child: child,
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }
}
