import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/item_info_multilayers/parts/info_cards_stack.dart';

double getHeightExpanded(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.23 < 230
      ? 230
      : MediaQuery.of(context).size.height * 0.23;
}

double getHeightCollapsed(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.3 < 250
      ? 250
      : MediaQuery.of(context).size.height * 0.3;
}

class ItemsMultilayerInfo extends StatefulWidget {
  const ItemsMultilayerInfo({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  State<ItemsMultilayerInfo> createState() => _ItemsMultilayerInfoState();
}

class _ItemsMultilayerInfoState extends State<ItemsMultilayerInfo> {
  bool isExpanded = false;

  int? activeIndex;

  void onIndexUpdate(int index) {
    activeIndex = activeIndex == index
        ? (index - 1) >= 0
            ? index - 1
            : null
        : index;

    isExpanded = activeIndex != null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation;

    final double finalHeight =
        isExpanded ? getHeightExpanded(context) : getHeightCollapsed(context);

    final child = InfoCardsStack(
      animation: animation,
      activeIndex: activeIndex,
      onIndexUpdate: onIndexUpdate,
      childrens: [
        ListView.builder(
          itemCount: 20,
          itemBuilder: ((context, index) {
            return ListTile(
              title: Text('Item $index'),
              subtitle: Text('Subtitle $index'),
              leading: const Icon(Icons.star),
            );
          }),
        ),
        GridView.builder(
          itemCount: 20,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return GridTile(
              child: Container(
                color: Colors.red,
              ),
            );
          },
        ),
        GridView.builder(
          itemCount: 20,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return GridTile(
              child: Container(
                color: Colors.red,
              ),
            );
          },
        ),
      ],
    );

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: finalHeight,
            child: Hero(
              tag: "HeroImage",
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: isExpanded ? 1 : 1.2,
                child: Image.asset(
                  'assets/images/person.jpeg',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: finalHeight * 0.6,
          bottom: 0,
          left: 0,
          right: 0,
          child: Hero(
            tag: "Cards",
            flightShuttleBuilder:
                (context, animation, direction, fromContext, toContext) {
              return child;
            },
            child: child,
          ),
        ),
        AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              if (!animation.isCompleted) {
                return const SizedBox();
              }
              return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 150),
                  builder: (context, animation, child) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: animation,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.only(top: isExpanded ? 25 : 50),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder()),
                              onPressed: () async {
                                setState(() {
                                  // isExpanded = false;
                                  // activeIndex = null;
                                });
                                // await Future<void>.delayed(
                                //     const Duration(milliseconds: 400));
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    );
                  });
            }),
      ],
    ));
  }
}
