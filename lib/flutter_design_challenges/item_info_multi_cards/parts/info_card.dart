import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.isActive,
    required this.color,
    required this.index,
    required this.activeIndex,
    required this.title,
    required this.content,
    required this.itemsCount,
  }) : super(key: key);

  final bool isActive;
  final Color color;
  final int index;
  final int? activeIndex;
  final String title;
  final Widget content;
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    Offset positionOffset = activeIndex == null
        ? Offset(0, 0.1 * (index + 1))
        : Offset(
            0,
            index == activeIndex
                ? 0.1 * index
                : index > activeIndex!
                    ? 1.0 - 0.1 * (itemsCount - index)
                    : 0.1 * index,
          );

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: positionOffset,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(60),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: activeIndex == index ||
                          (activeIndex == null && index == itemsCount - 1)
                      ? content
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
