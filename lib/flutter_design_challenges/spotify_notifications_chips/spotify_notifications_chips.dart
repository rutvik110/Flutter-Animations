import 'package:flutter/material.dart';

class SpotifyNotificationsChips extends StatelessWidget {
  const SpotifyNotificationsChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: NotificationTypes(),
      ),
    );
  }
}

class NotificationTypes extends StatefulWidget {
  const NotificationTypes({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationTypes> createState() => _NotificationTypesState();
}

class _NotificationTypesState extends State<NotificationTypes> {
  bool showCloseButton = false;

  String? selectedValue;

  final List<String> _types = [
    'Music',
    'Talks',
    'Podcasts',
  ];

  final List<String> defaultList = [
    "Notification 1",
    "Notification 2",
    "Notification 3",
  ];

  final List<String> musicNotifications = [
    'Hey Boy!',
    'Light Switch',
    'High',
  ];
  final List<String> talksNotifications = [
    'Talk 1',
    'Talk 2',
    'Talk 3',
  ];
  final List<String> podacastNotifications = [
    'Podcast 1',
    'Podcast 2',
    'Podcast 3',
  ];

  String getTitle(int index) {
    late String title;
    switch (selectedValue) {
      case "Music":
        title = musicNotifications[index];

        return title;
        break;
      case "Talks":
        title = talksNotifications[index];

        return title;
        break;
      case "Podcasts":
        title = podacastNotifications[index];

        return title;
        break;
      default:
        title = defaultList[index];

        return title;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedValue = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 100,
        ),
        // Notifications Types Chips list
        SizedBox(
            height: 34,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showCloseButton)
                  const SizedBox(
                    width: 20,
                  ),
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 150,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          showCloseButton ? Colors.white : Colors.transparent,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: showCloseButton
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              showCloseButton = false;
                              selectedValue = null;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  child: SizedBox(
                    width: showCloseButton ? 20 : 0,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(0).copyWith(
                        left: showCloseButton ? 0 : 20,
                      ),
                      itemCount: _types.length,
                      itemBuilder: (context, index) {
                        return NotificationTypeChip(
                            value: _types[index],
                            selectedValue: selectedValue,
                            onTap: (value) {
                              if (selectedValue != value) {
                                setState(() {
                                  showCloseButton = true;
                                  selectedValue = value;
                                });
                              } else {
                                setState(() {
                                  showCloseButton = false;
                                  selectedValue = null;
                                });
                              }
                            });
                      }),
                ),
              ],
            )),
        // Items list for particular type of notifications
        Expanded(
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                String title = getTitle(index);

                return ListTile(
                  leading: const CircleAvatar(),
                  title: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(''),
                  trailing: const Icon(Icons.chevron_right),
                );
              }),
        ),
      ],
    );
  }
}

class NotificationTypeChip extends StatelessWidget {
  const NotificationTypeChip({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  }) : super(key: key);

  final String? selectedValue;
  final String value;
  final Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(value);
      },
      child: Opacity(
        opacity: selectedValue == null || selectedValue == value ? 1 : 0,
        child: Tooltip(
          message: value,
          child: AnimatedContainer(
            duration:
                Duration(milliseconds: selectedValue == value ? 300 : 150),
            margin: const EdgeInsets.only(right: 5),
            width: selectedValue == null || selectedValue == value ? 100 : 0,
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: selectedValue == value ? Colors.green : null,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
