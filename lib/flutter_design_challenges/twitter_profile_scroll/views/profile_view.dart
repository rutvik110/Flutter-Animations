import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/models/profile.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/sliver_custom_appbar/sliver_custom_appbar.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/sliver_tabbar.dart';
import 'package:flutter_animations/flutter_design_challenges/twitter_profile_scroll/styles.dart';

class TwitterProfileView extends StatefulWidget {
  const TwitterProfileView({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  State<TwitterProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<TwitterProfileView> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (context, value) {
                  const double profileAvatarDiameter = 100;
                  // update to shift profile avatar position from bottom edge center
                  const double profileAvatarShift = 20;

                  return [
                    TwitterProfileSliverCustomeAppBar(
                      profile: profile,
                      scrollController: scrollController,
                      profileAvatarDiameter: profileAvatarDiameter,
                      profileAvatarShift: profileAvatarShift,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height:
                                profileAvatarDiameter / 2 + profileAvatarShift,
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  profile.location,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: const Color(0xFF777E93),
                                      ),
                                ),
                                Text(
                                  profile.slogan,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontSize: 17,
                                      ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverCustomTabbar(
                      maxAppBarHeight: 50,
                      minAppBarHeight: 50,
                      tabBar: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: const Color(0xFF777E93),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        splashBorderRadius: BorderRadius.circular(100),
                        tabs: const [
                          Tab(
                            height: 70,
                            child: Text(
                              "Tweets",
                              style: TextStyle(),
                            ),
                          ),
                          Tab(
                            height: 70,
                            child: Text(
                              "Replies",
                              style: TextStyle(),
                            ),
                          ),
                          Tab(
                            height: 70,
                            child: Text(
                              "Media",
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ];
                },
                body: ProfileViewTabs(
                  profile: profile,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileViewTabs extends StatelessWidget {
  const ProfileViewTabs({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.lg,
      ),
      child: TabBarView(
        children: [
          ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text("Tweet ${index + 1}"),
                );
              })),
          ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text("Replies ${index + 1}"),
                );
              })),
          ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text("Media ${index + 1}"),
                );
              })),
        ],
      ),
    );
  }
}
