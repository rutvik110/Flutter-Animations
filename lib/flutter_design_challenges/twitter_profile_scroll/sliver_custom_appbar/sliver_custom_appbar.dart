import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/models/profile.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/sliver_custom_appbar/custom_flexible_space.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/sliver_custom_appbar/sliver_appbar_delegate.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/styles.dart';

class TwitterProfileSliverCustomeAppBar extends StatelessWidget {
  const TwitterProfileSliverCustomeAppBar({
    Key? key,
    this.maxHeight,
    this.minHeight,
    required this.profile,
    required this.scrollController,
    required this.profileAvatarShift,
    required this.profileAvatarDiameter,
  }) : super(key: key);

  final double? maxHeight;
  final double? minHeight;
  final ScrollController scrollController;

  final Profile profile;
  final double profileAvatarDiameter;
  final double profileAvatarShift;

  @override
  Widget build(BuildContext context) {
    final maxAppBarHeight =
        maxHeight ?? MediaQuery.of(context).size.height * 0.25;
    final minAppBarHeight = minHeight ??
        MediaQuery.of(context).padding.top +
            MediaQuery.of(context).size.height * 0.09;

    return AnimatedBuilder(
      animation: scrollController,
      builder: ((context, child) {
        return SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
            maxHeight: maxAppBarHeight,
            minHeight: minAppBarHeight,
            builder: (context, shrinkOffset) {
              // final double shrinkToMaxAppBarHeightRatio =
              //     shrinkOffset / maxAppBarHeight;
              final double maxHeightBottomEdgeToMinHeightAppbarHitRatio =
                  (shrinkOffset / (maxAppBarHeight - minAppBarHeight))
                      .clamp(0, 1);
              final isAppbarActive =
                  maxHeightBottomEdgeToMinHeightAppbarHitRatio >= 1;
              final double minHeightBottomEdgeToTopHit = isAppbarActive
                  ? (maxAppBarHeight - shrinkOffset) / minAppBarHeight
                  : 0;

              // final showingFixedAppBar = shrinkToMaxAppBarHeightRatio > 0.7;

              // final appbarBottomToTopratio =
              //     1 - ((maxAppBarHeight - shrinkOffset) / minAppBarHeight);
              final double profileAvatarBottomPaddingRatio =
                  isAppbarActive ? 1 - minHeightBottomEdgeToTopHit : 0;

              // for profile title
              final offset = scrollController.offset;
              final double appbarTitleToTopratio = (1 -
                      ((maxAppBarHeight +

                              /// adjusted offset to make the title appear when the profile name and userid are almost at the
                              /// bottom edge of the app bar in min-height state
                              profileAvatarDiameter / 2 +
                              profileAvatarShift
                              //
                              -
                              (offset)) /
                          minAppBarHeight))
                  .clamp(-1, 1.0);
              final isAppbarTitleActive = appbarTitleToTopratio >= 0;
              final double appbarTitleOpacity =
                  isAppbarTitleActive ? appbarTitleToTopratio : 0;
              log(minHeightBottomEdgeToTopHit.toString());
              final childrens = [
                TwitterProfileCustomFlexibleSpace(
                  titleOpacity: appbarTitleOpacity,
                  profile: profile,
                ),
                ProfilePicAvatar(
                  appBarToTopHit: minHeightBottomEdgeToTopHit,
                  bottomToAppbarHitBeforeBlur:
                      maxHeightBottomEdgeToMinHeightAppbarHitRatio,
                  profileAvatarBottomPaddingRatio:
                      profileAvatarBottomPaddingRatio,
                  profile: profile,
                  isAppbarActive: isAppbarActive,
                  profileAvatarDiameter: profileAvatarDiameter,
                  profileAvatarShift: profileAvatarShift,
                )
              ];

              return Stack(
                alignment: Alignment.topCenter,
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children:
                    isAppbarActive ? childrens.reversed.toList() : childrens,
              );
            },
          ),
        );
      }),
      // child: ,
    );
  }
}

class ProfilePicAvatar extends StatelessWidget {
  const ProfilePicAvatar({
    Key? key,
    required this.appBarToTopHit,
    required this.bottomToAppbarHitBeforeBlur,
    required this.profileAvatarBottomPaddingRatio,
    required this.profile,
    required this.isAppbarActive,
    required this.profileAvatarDiameter,
    required this.profileAvatarShift,
  }) : super(key: key);

  final double appBarToTopHit;
  final double bottomToAppbarHitBeforeBlur;
  final double profileAvatarBottomPaddingRatio;
  final Profile profile;
  final bool isAppbarActive;
  final double profileAvatarDiameter;
  final double profileAvatarShift;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final profileAvatarRadius = profileAvatarDiameter / 2;
      final bottomPadding = profileAvatarRadius + profileAvatarShift;
      final scaleRatio = bottomPadding / profileAvatarDiameter;
      final scale = lerpDouble(1, scaleRatio, bottomToAppbarHitBeforeBlur)!;

      final decreasingPadding =
          profileAvatarBottomPaddingRatio * (profileAvatarDiameter * 1.2);

      return Positioned(
        bottom: -bottomPadding -
            bottomToAppbarHitBeforeBlur * bottomPadding * scale +
            profileAvatarShift * (1 + scale) * bottomToAppbarHitBeforeBlur +
            decreasingPadding,
        left: Insets.sm * (1 - bottomToAppbarHitBeforeBlur),
        child: Transform.scale(
          origin: const Offset(0.5, 0.5),
          scale: scale,
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: profileAvatarRadius,
              backgroundImage: AssetImage(
                profile.profile_pic,
              ),
            ),
          ),
        ),
      );
    });
  }
}
