import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/flutter_design_challenges/spotify_page/spotify_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color(0xFF0e7cfe),
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
        home: const SpotifyPage());
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Center(
        child: SizedBox(
          height: 896.0,
          width: 414.0,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Chirpy(),
          ),
        ),
      ),
    );
  }
}

class Chirpy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emojis = ['😎', '🦄', '👤', '⚓️', '🥸'];
    final names = [
      'Nick',
      'Marton',
      'Luke',
      'Matheus',
      'Salvatore',
    ];
    const colors = [
      Color(0xffffc7d0),
      Color(0xffff95a2),
      Color(0xffa8e4f1),
      Color(0xffffffff),
      Color(0xffc3c1e6),
    ];
    return Scaffold(
      backgroundColor: const Color(0xff5b61b9),
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) =>
                  [HomeHeader(colors: colors, emojis: emojis)],
          body: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 48.0,
                left: 24.0,
                right: 24.0,
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      [
                        ...List.generate(
                          emojis.length,
                          (index) => ChatItem(
                            timestap: '9:41',
                            name: names[index],
                            message: index.isEven
                                ? 'Hello there'
                                : 'Something interesting and cool...',
                            emoji: emojis[index],
                            backgroundColor: colors[index],
                          ),
                        ),
                      ],
                    ),
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

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
    required this.emojis,
    required this.colors,
  }) : super(key: key);

  final List<String> emojis;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: SliverAppBarDelegate(
        minHeight: 0.0,
        maxHeight: 200.0,
        builder: (context, shrinkOffset) {
          final _emojiBarSize = 22.0 * (1 - (shrinkOffset / 200));
          final _titleSize = (1 - (shrinkOffset / 120)).clamp(0.0, 1.0);

          return ClipRRect(
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: ScaleTransition(
                      alignment: Alignment.topLeft,
                      scale: AlwaysStoppedAnimation(_titleSize),
                      child: const Text(
                        'Chat with \n your Friends',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.4),
                        radius: 24.0,
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: _emojiBarSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      ...List.generate(
                        emojis.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                          ),
                          child: CircleAvatar(
                            backgroundColor: colors[index],
                            radius: 24.0,
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: kThemeAnimationDuration,
                                style: TextStyle(fontSize: _emojiBarSize),
                                child: Text(
                                  emojis[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.name,
    required this.message,
    required this.timestap,
    required this.backgroundColor,
    required this.emoji,
    this.onTap,
  }) : super(key: key);
  final String name;
  final String message;
  final String timestap;
  final Color backgroundColor;
  final String emoji;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 12.0,
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 36.0,
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 36.0),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Color(0xff362856),
                fontWeight: FontWeight.w800,
                fontSize: 20.0,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  timestap,
                  style: const TextStyle(
                    color: Color(0xffb9b3c4),
                  ),
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff675d80),
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

typedef _SliverAppBarDelegateBuilder = Widget Function(
  BuildContext context,
  double shrinkOffset,
);

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });
  final double minHeight;
  final double maxHeight;
  final _SliverAppBarDelegateBuilder builder;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: builder(context, shrinkOffset),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}
