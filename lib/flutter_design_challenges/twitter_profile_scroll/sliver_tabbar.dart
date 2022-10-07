import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/styles.dart';

class SliverCustomTabbar extends StatelessWidget {
  const SliverCustomTabbar({
    Key? key,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
    required this.tabBar,
  }) : super(key: key);

  final double maxAppBarHeight;
  final double minAppBarHeight;
  final TabBar tabBar;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      // floating: true,
      delegate: _SliverAppBarDelegate(tabBar),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: [
          const SizedBox(
            height: 0,
            width: double.infinity,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[100]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Corners.extralgRadius,
                  topRight: Corners.extralgRadius,
                ),
              ),
              child: SizedBox(
                width: 200,
                child: _tabBar,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
