import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/item_info_multilayers/parts/info_card.dart';

class InfoCardsStack extends StatelessWidget {
  const InfoCardsStack({
    Key? key,
    required this.animation,
    required this.onIndexUpdate,
    required this.activeIndex,
    required this.childrens,
  }) : super(key: key);

  final Animation<double> animation;
  final Function(int index) onIndexUpdate;
  final int? activeIndex;
  final List<Widget> childrens;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: childrens.asMap().entries.map<Widget>((entry) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(
                -animation.value - 0.5 * entry.key,
                animation.value + 0.5 * entry.key,
              ),
              end: const Offset(0, 0),
            ).animate(animation),
            child: GestureDetector(
              onTap: () {
                onIndexUpdate(entry.key);
              },
              child: InfoCard(
                title: titles[entry.key],
                isActive: entry.key == activeIndex,
                color: colors[entry.key],
                acitveIndex: activeIndex,
                index: entry.key,
                content: entry.value,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
];
List<String> titles = [
  "Sarah",
  "About",
  "Photos",
];
