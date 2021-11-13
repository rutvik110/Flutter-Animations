// import 'package:flutter/material.dart';

// class SpotifyAlbumView extends StatefulWidget {
//   const SpotifyAlbumView({Key? key}) : super(key: key);

//   @override
//   _SpotifyAlbumViewState createState() => _SpotifyAlbumViewState();
// }

// class _SpotifyAlbumViewState extends State<SpotifyAlbumView> {
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DecoratedBox(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 kPrimaryColor,
//                 Colors.black,
//               ],
//               stops: [
//                 0,
//                 0.7
//               ]),
//         ),
//         child: CustomScrollView(
//           controller: _scrollController,
//           slivers: [

//           ],
//         ),
//       ),
//     );
//   }
// }
