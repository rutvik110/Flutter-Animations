// Inspiration : https://dribbble.com/shots/12114793-Challenge-App-Interactions-Choosing-Coach

import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/item_info_multi_cards/parts/item_view.dart';

class ItemInfoMultiCards extends StatelessWidget {
  const ItemInfoMultiCards({Key? key}) : super(key: key);

  void navigateToInfo(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        reverseTransitionDuration: const Duration(milliseconds: 1000),
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: ((context, animation, secondaryAnimation) {
          return ItemView(animation: animation);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => navigateToInfo(context),
                child: Hero(
                  tag: "HeroImage",
                  child: Image.asset(
                    'assets/images/person.jpeg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            FractionalTranslation(
              translation: const Offset(-1.0, 1.0),
              child: Hero(
                tag: "Cards",
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
