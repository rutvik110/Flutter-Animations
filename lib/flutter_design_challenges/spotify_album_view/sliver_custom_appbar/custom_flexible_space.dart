import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/spotify_album_view/const.dart';

class AlbumImage extends StatelessWidget {
  const AlbumImage({
    Key? key,
    required this.padding,
    required this.animateOpacityToZero,
    required this.animateAlbumImage,
    required this.shrinkToMaxAppBarHeightRatio,
    required this.albumImageSize,
  }) : super(key: key);

  final EdgeInsets padding;
  final bool animateOpacityToZero;
  final bool animateAlbumImage;
  final double shrinkToMaxAppBarHeightRatio;
  final double albumImageSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ));
  }
}
