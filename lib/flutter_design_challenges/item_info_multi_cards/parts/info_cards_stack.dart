import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/item_info_multi_cards/parts/info_card.dart';

List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
];
List<String> titles = [
  "Sarah",
  "About",
  "Photos",
  "Travel",
  "Friends",
];

class InfoCardsStack extends StatefulWidget {
  const InfoCardsStack({
    Key? key,
    required this.animation,
    required this.activeIndexNotifier,
    required this.childrens,
    required this.itemsCount,
  })  : assert(itemsCount == childrens.length,
            "itemsCount should be equal to length of the childrens"),
        super(key: key);

  final Animation<double> animation;
  final ValueNotifier<int?> activeIndexNotifier;
  final List<Widget> childrens;
  final int itemsCount;

  @override
  State<InfoCardsStack> createState() => _InfoCardsStackState();
}

class _InfoCardsStackState extends State<InfoCardsStack> {
  int? activeIndex;

  late ScrollController controller1;
  late ScrollController controller2;
  late ScrollController controller3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = ScrollController();
    controller2 = ScrollController();
    controller3 = ScrollController();
  }

  void onIndexUpdate(int index) {
    final updatedActiveIndex = activeIndex == index
        ? (index - 1) >= 0
            ? index - 1
            : null
        : index;
    if (updatedActiveIndex == widget.activeIndexNotifier.value) {
      widget.activeIndexNotifier.value = null;
      widget.activeIndexNotifier.notifyListeners();
    } else {
      widget.activeIndexNotifier.value = updatedActiveIndex;
    }
  }

  double get getBottomPadding {
    //get the bottom padding of the card depending on the number of cards on top of it
    // such that its content is fully visible when scrolled to bottom of the card

    return activeIndex == null
        ? 0
        : MediaQuery.of(context).size.height * 0.1 * widget.itemsCount;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
        valueListenable: widget.activeIndexNotifier,
        builder: (context, value, _) {
          return Material(
            color: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: widget.childrens.asMap().entries.map<Widget>((entry) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(
                      -widget.animation.value - 0.5 * entry.key,
                      widget.animation.value + 0.5 * entry.key,
                    ),
                    end: const Offset(0, 0),
                  ).animate(widget.animation),
                  child: GestureDetector(
                    onTap: () {
                      onIndexUpdate(entry.key);
                    },
                    child: InfoCard(
                      title: titles[entry.key],
                      isActive: entry.key == widget.activeIndexNotifier.value,
                      color: colors[entry.key],
                      activeIndex: widget.activeIndexNotifier.value,
                      index: entry.key,
                      content: entry.value,
                      itemsCount: widget.itemsCount,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
