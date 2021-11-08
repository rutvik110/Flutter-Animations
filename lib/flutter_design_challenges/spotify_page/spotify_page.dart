import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations/main.dart';

class SpotifyPage extends StatefulWidget {
  const SpotifyPage({Key? key}) : super(key: key);

  @override
  _SpotifyPageState createState() => _SpotifyPageState();
}

class _SpotifyPageState extends State<SpotifyPage> {
  late ScrollController _scrollController;

  late double maxAppBarHeight;
  late double minAppBarHeight;
  late double buttonSize;
  late double subHeaderHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    maxAppBarHeight = MediaQuery.of(context).size.height * 0.5;
    minAppBarHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.1;
    //TODO:set max size
    buttonSize = (MediaQuery.of(context).size.width / 320) * 50;
    subHeaderHeight = 180;
    return Material(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9B6AF2),
                Colors.black,
              ],
              stops: [
                0,
                0.7
              ]),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              clipBehavior: Clip.none,
              slivers: [
                PageHeader(
                  onEnd: () {},
                  maxAppBarHeight: maxAppBarHeight,
                  minAppBarHeight: minAppBarHeight,
                ),
                SliverToBoxAdapter(
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
                      height: 180,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: ListTile(
                        title: const Text(
                          "Tides",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        subtitle: const Text("Ed Sheeran",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            PlayButton(
              scrollController: _scrollController,
              maxAppBarHeight: maxAppBarHeight,
              minAppBarHeight: minAppBarHeight,
              buttonSize: buttonSize,
              subHeaderHeight: subHeaderHeight,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
    required this.scrollController,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
    required this.buttonSize,
    required this.subHeaderHeight,
  }) : super(key: key);

  final ScrollController scrollController;
  final double maxAppBarHeight;
  final double minAppBarHeight;
  final double buttonSize;
  final double subHeaderHeight;

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

  double get getPosition {
    double res = widget.maxAppBarHeight;
    double finalPosition = widget.minAppBarHeight - widget.buttonSize / 2;
    if (widget.scrollController.hasClients) {
      double offset = widget.scrollController.offset;
      //if want to lower button then first add later subtract
      //if want to move up then first subtract later add

      if (offset <
          (res -
              finalPosition +
              widget.subHeaderHeight -
              widget.buttonSize -
              10)) {
        res -= offset -
            widget.subHeaderHeight +
            widget.buttonSize +
            10; //subtract from res
      } else {
        res = finalPosition;
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: getPosition,
      right: 10,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFF78FF45),
          fixedSize: Size(widget.buttonSize, widget.buttonSize),
          shape: CircleBorder(),
        ),
        onPressed: () {},
        child: const Icon(
          Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    required this.onEnd,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
  }) : super(key: key);

  final VoidCallback onEnd;
  final double maxAppBarHeight;
  final double minAppBarHeight;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            maxHeight: maxAppBarHeight,
            minHeight: minAppBarHeight,
            builder: (context, shrinkOffset) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  gradient:
                      shrinkOffset >= MediaQuery.of(context).size.height * 0.35
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  Color(0xFF816EC1),
                                  // Colors.black,
                                  Color(0xFF5E4E95),
                                ],
                              stops: [
                                  0,
                                  // 0.6,
                                  0.5
                                ])
                          : null,
                ),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    right: 10,
                    left: 10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: shrinkOffset >=
                              MediaQuery.of(context).size.height * 0.2
                          ? -(shrinkOffset -
                                  MediaQuery.of(context).size.height * 0.2) +
                              MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.height * 0.05,
                      child: AnimatedOpacity(
                        onEnd: onEnd,
                        duration: const Duration(milliseconds: 500),
                        opacity: shrinkOffset >=
                                MediaQuery.of(context).size.height * 0.2
                            ? 0
                            : 1,
                        child: Container(
                          height:
                              // MediaQuery.of(context).size.height * 0.3 -
                              //             shrinkOffset / 2 ==
                              //         100
                              //     ? 100
                              //     :
                              MediaQuery.of(context).size.height * 0.3 -
                                  shrinkOffset / 2,
                          width:
                              //  MediaQuery.of(context).size.height * 0.3 -
                              //             shrinkOffset / 2 ==
                              //         100
                              //     ? 100
                              //     :
                              MediaQuery.of(context).size.height * 0.3 -
                                  shrinkOffset / 2,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            image: DecorationImage(
                              image: NetworkImage(albumImageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}

String albumImageUrl =
    "https://upload.wikimedia.org/wikipedia/en/c/cd/Ed_Sheeran_-_Equals.png";

String edImageUrl =
    "https://i.scdn.co/image/ab6761610000e5eb12a2ef08d00dd7451a6dbed6";
