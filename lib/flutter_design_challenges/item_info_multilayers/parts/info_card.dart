import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    Key? key,
    required this.isActive,
    required this.color,
    required this.index,
    required this.acitveIndex,
    required this.title,
    required this.content,
  }) : super(key: key);

  final bool isActive;
  final Color color;
  final int index;
  final int? acitveIndex;
  final String title;
  final Widget content;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  late Offset positionOffset;

  Offset updatePositionOffset() {
    if (widget.acitveIndex == null) {
      return positionOffset = Offset(0, 0.1 * (widget.index + 1));
    } else {
      return positionOffset = Offset(
        0,
        widget.index == widget.acitveIndex
            ? 0.1 * widget.index
            : widget.index > widget.acitveIndex!
                ? 1.0 - 0.1 * (3 - widget.index)
                : 0.1 * widget.index,
      );
    }
  }

  double get getBottomPadding {
    //get the bottom padding of the card depending on the number of cards on top of it
    // such that its content is fully visible when scrolled to bottom of the card

    return widget.acitveIndex == null
        ? 0
        : MediaQuery.of(context).size.height * 0.23;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updatePositionOffset();
  }

  @override
  void didUpdateWidget(covariant InfoCard oldWidget) {
    // TODO: implement didUpdateWidget
    // TODO: implement didChangeDependencies
    if (oldWidget.acitveIndex != widget.acitveIndex) {
      updatePositionOffset();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: positionOffset,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
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
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: widget.acitveIndex == widget.index ||
                          (widget.acitveIndex == null && widget.index == 2)
                      ? widget.content
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
