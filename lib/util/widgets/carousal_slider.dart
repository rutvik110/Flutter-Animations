import 'dart:developer';

import 'package:flutter/material.dart';

class CarousalSlider extends StatefulWidget {
  const CarousalSlider({
    Key? key,
    required this.childrens,
    required this.builder,
    required this.carouselOptions,
  }) : super(key: key);

  final List<Widget> childrens;
  final CarouselOptions carouselOptions;
  final Widget Function(
    BuildContext context,
    int index,
    Widget child,
    double primaryAnimation,
    double secondaryAnimation,
  ) builder;

  @override
  State<CarousalSlider> createState() => _CarousalSliderState();
}

class _CarousalSliderState extends State<CarousalSlider> {
  late final PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      viewportFraction: widget.carouselOptions.viewportFraction ?? 0.8,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.carouselOptions.height,
      child: PageView.builder(
        controller: pageController,
        itemCount: widget.childrens.length,
        padEnds: widget.carouselOptions.padEnds,
        onPageChanged: (int value) {
          log(value.toString());
        },
        itemBuilder: (BuildContext context, int index) {
          return AnimatedBuilder(
            animation: pageController,
            child: widget.childrens[index],
            builder: (BuildContext context, Widget? child) {
              final ScrollPosition position = pageController.position;
              late final double value;
              if (position.hasPixels && position.hasContentDimensions) {
                final double? page = pageController.page;
                if (page != null) {
                  value = page - index;
                }
              } else {
                final BuildContext storageContext =
                    pageController.position.context.storageContext;
                final double? previousSavedPosition =
                    PageStorage.of(storageContext)?.readState(storageContext)
                        as double?;
                if (previousSavedPosition != null) {
                  value = previousSavedPosition - index.toDouble();
                } else {
                  value = pageController.initialPage - index.toDouble();
                }
              }
              final double distortionRatio =
                  (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);

              final double distortionValue =
                  Curves.linear.transform(distortionRatio.abs());

              return widget.builder(
                context,
                index,
                child!,
                value,
                distortionValue,
              );
            },
          );
        },
      ),
    );
  }
}

class CarouselOptions {
  CarouselOptions({
    required this.height,
    this.viewportFraction,
    this.padEnds = true,
  });

  final double height;
  final double? viewportFraction;
  final bool padEnds;
}
