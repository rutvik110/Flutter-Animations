import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_design_challenges/spotify_album_page/const.dart';
import 'package:flutter_animations/main.dart';

class SliverCustomeAppBar extends StatelessWidget {
  const SliverCustomeAppBar({
    Key? key,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
  }) : super(key: key);

  final double maxAppBarHeight;
  final double minAppBarHeight;

  @override
  Widget build(BuildContext context) {
    //status bar height
    final topPadding = MediaQuery.of(context).size.height * 0.05;
    //app bar content padding from top and horizantal padding
    var padding = EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + topPadding,
        right: 10,
        left: 10);

    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            maxHeight: maxAppBarHeight,
            minHeight: minAppBarHeight,
            builder: (context, shrinkOffset) {
              final double shrinkToMaxAppBarHeightRatio =
                  shrinkOffset / maxAppBarHeight;
              const double animatAlbumImageFromPoint = 0.4;
              final animateAlbumImage =
                  shrinkToMaxAppBarHeightRatio >= animatAlbumImageFromPoint;
              final animateOpacityToZero = shrinkToMaxAppBarHeightRatio > 0.6;
              final albumPositionFromTop = animateAlbumImage
                  ? (animatAlbumImageFromPoint - shrinkToMaxAppBarHeightRatio) *
                      maxAppBarHeight
                  : null;
              final albumImageSize =
                  MediaQuery.of(context).size.height * 0.3 - shrinkOffset / 2;
              final showAppBar = shrinkToMaxAppBarHeightRatio > 0.7;
              final appBarOpacityDouble = showAppBar
                  ? 1 - (maxAppBarHeight - shrinkOffset) / minAppBarHeight
                  : 0;

              return Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: albumPositionFromTop,
                    child: Padding(
                      padding: padding,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        opacity: animateOpacityToZero
                            ? 0
                            : animateAlbumImage
                                ? 1 - shrinkToMaxAppBarHeightRatio
                                : 1,
                        child: Container(
                          height: albumImageSize,
                          width: albumImageSize,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            image: DecorationImage(
                              image: NetworkImage(albumImageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black87,
                                spreadRadius: 1,
                                blurRadius: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      gradient: showAppBar
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  kAppBarPrimary,
                                  kAppBarSecondary,
                                ],
                              stops: [
                                  0,
                                  0.5
                                ])
                          : null,
                    ),
                    child: Padding(
                      padding: padding,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: double.maxFinite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 30),
                            AnimatedOpacity(
                              opacity: appBarOpacityDouble.toDouble() < 0
                                  ? 0
                                  : appBarOpacityDouble.toDouble(),
                              duration: const Duration(milliseconds: 100),
                              child: const Text("=",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
