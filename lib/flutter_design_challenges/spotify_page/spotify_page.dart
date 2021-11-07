import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/sliver_multi_box_adaptor.dart';
import 'package:flutter_animations/main.dart';

class SpotifyPage extends StatefulWidget {
  const SpotifyPage({Key? key}) : super(key: key);

  @override
  _SpotifyPageState createState() => _SpotifyPageState();
}

class _SpotifyPageState extends State<SpotifyPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // _scrollController.addListener(() {
    //   double res = MediaQuery.of(context).size.height * 0.4;
    //   if (_scrollController.hasClients) {
    //     double offset = _scrollController.offset;
    //     if (offset < (res - MediaQuery.of(context).padding.top)) {
    //       // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //       //   statusBarColor: Colors.black45, // status bar color
    //       // ));
    //       res -= offset;
    //     } else {
    //       res = MediaQuery.of(context).padding.top;
    //       // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //       //   statusBarColor: Colors.deepPurple, // status bar color
    //       // ));
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            clipBehavior: Clip.none,
            slivers: [
              PageHeader(
                onEnd: () {},
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [Icon(Icons.add)],
                ),
              ),
              SliverList(
                  delegate:
                      SliverChildBuilderDelegate((context, index) => ListTile(
                            title: Text(
                              index.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ))),
            ],
          ),
          PlayButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.scrollController.addListener(() {
      setState(() {});
    });
  }

  double get top {
    double res = MediaQuery.of(context).size.height * 0.4;
    if (widget.scrollController.hasClients) {
      double offset = widget.scrollController.offset;
      if (offset < (res - (MediaQuery.of(context).padding.top) * 2)) {
        res -= offset;
      } else {
        res = MediaQuery.of(context).padding.top * 2;
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: 0,
      child: ElevatedButton(
          style: OutlinedButton.styleFrom(
            fixedSize: Size(80, 80),
            shape: CircleBorder(),
          ),
          onPressed: () {},
          child: Icon(Icons.play_lesson)),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    required this.onEnd,
  }) : super(key: key);

  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            minHeight: MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height * 0.1,
            builder: (context, shrinkOffset) {
              return Container(
                color: shrinkOffset >= MediaQuery.of(context).size.height * 0.3
                    ? Colors.red
                    : Colors.transparent,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),

                // padding: const EdgeInsets.only(top: 10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: shrinkOffset >=
                              MediaQuery.of(context).size.height * 0.2
                          ? -(shrinkOffset -
                              MediaQuery.of(context).size.height * 0.2)
                          : 10,
                      child: AnimatedOpacity(
                        onEnd: onEnd,
                        duration: const Duration(milliseconds: 500),
                        opacity: shrinkOffset >=
                                MediaQuery.of(context).size.height * 0.2
                            ? 0
                            : 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3 -
                                      shrinkOffset / 2 ==
                                  100
                              ? 100
                              : MediaQuery.of(context).size.height * 0.3 -
                                  shrinkOffset / 2,
                          width: MediaQuery.of(context).size.height * 0.3 -
                                      shrinkOffset / 2 ==
                                  100
                              ? 100
                              : MediaQuery.of(context).size.height * 0.3 -
                                  shrinkOffset / 2,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: MediaQuery.of(context).size.width,
                      // color: shrinkOffset >=
                      //         MediaQuery.of(context).size.height * 0.3
                      //     ? Colors.red
                      //     : Colors.transparent,
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.arrow_back),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
