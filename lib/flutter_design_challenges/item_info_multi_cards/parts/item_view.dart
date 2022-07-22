import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/item_info_multi_cards/parts/info_cards_stack.dart';

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

class ItemView extends StatefulWidget {
  const ItemView({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  State<ItemView> createState() => _ItemsMultilayerInfoState();
}

class _ItemsMultilayerInfoState extends State<ItemView> {
  late ValueNotifier<int?> activeIndexNotifier;

  late ScrollController controller1;
  late ScrollController controller2;
  late ScrollController controller3;
  late int itemsCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = ScrollController();
    controller2 = ScrollController();
    controller3 = ScrollController();
    activeIndexNotifier = ValueNotifier<int?>(null);
    itemsCount = 3;
  }

  double get getFinalHeight {
    return activeIndexNotifier.value != null
        ? getHeightExpanded(context)
        : getHeightCollapsed(context);
  }

  double get getBottomPadding {
    //get the bottom padding of the card depending on the number of cards on top of it
    // such that its content is fully visible when scrolled to bottom of the card

    return activeIndexNotifier.value == null
        ? 0
        : MediaQuery.of(context).size.height * 0.08 * itemsCount;
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.animation;

    final infoCardsStack = InfoCardsStack(
      activeIndexNotifier: activeIndexNotifier,
      animation: animation,
      itemsCount: itemsCount,
      childrens: [
        ListView.builder(
          controller: controller1,
          padding: EdgeInsets.only(bottom: getBottomPadding),
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
          controller: controller2,
          itemCount: 20,
          padding: EdgeInsets.only(bottom: getBottomPadding),
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
          controller: controller3,
          itemCount: 20,
          padding: EdgeInsets.only(bottom: getBottomPadding),
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
          child: ValueListenableBuilder<int?>(
              valueListenable: activeIndexNotifier,
              child: Image.asset(
                'assets/images/person.jpeg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              builder: (context, activeIndex, child) {
                final isExpanded = activeIndex != null;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: getFinalHeight,
                  child: Hero(
                    tag: "HeroImage",
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: isExpanded ? 1 : 1.2,
                      child: child,
                    ),
                  ),
                );
              }),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: getFinalHeight * 0.6,
          bottom: 0,
          left: 0,
          right: 0,
          child: Hero(
            tag: "Cards",
            flightShuttleBuilder:
                (context, animation, direction, fromContext, toContext) {
              return infoCardsStack;
            },
            child: infoCardsStack,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                if (!animation.isCompleted) {
                  return const SizedBox();
                }
                return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 150),
                    child: ValueListenableBuilder<int?>(
                        valueListenable: activeIndexNotifier,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder()),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        builder: (context, activeIndex, child) {
                          final isExpanded = activeIndex != null;

                          return AnimatedPadding(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.only(top: isExpanded ? 25 : 50),
                            child: child,
                          );
                        }),
                    builder: (context, animation, child) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: animation,
                        child: child,
                      );
                    });
              }),
        ),
      ],
    ));
  }
}
