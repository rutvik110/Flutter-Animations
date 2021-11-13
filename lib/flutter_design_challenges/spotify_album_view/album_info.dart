import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_design_challenges/spotify_album_view/const.dart';

class AlbumInfo extends StatelessWidget {
  const AlbumInfo({
    Key? key,
    required this.infoBoxHeight,
  }) : super(key: key);

  final double infoBoxHeight;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
              stops: [
                0.00022,
                1.0,
              ]),
        ),
        child: SizedBox(
          height: infoBoxHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "=",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      backgroundImage: NetworkImage(edImageUrl),
                    ),
                    const Text(
                      "Ed Sheeran",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox.shrink()
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Album . 2021",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
