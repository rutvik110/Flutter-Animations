import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/models/profile.dart';

class TwitterProfileCustomFlexibleSpace extends StatelessWidget {
  const TwitterProfileCustomFlexibleSpace({
    Key? key,
    required this.titleOpacity,
    required this.profile,
  }) : super(key: key);

  final double titleOpacity;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(profile.banner_pic),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: titleOpacity * 20,
            sigmaY: titleOpacity * 20,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionalTranslation(
              translation: Offset(
                0,
                (1 - titleOpacity),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    profile.location,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
