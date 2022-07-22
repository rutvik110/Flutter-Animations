import 'package:flutter/material.dart';
import 'package:flutter_animations/flutter_design_challenges/item_info_multilayers/parts/items_multilayer_info.dart';

class InfoMultilayerItem extends StatelessWidget {
  const InfoMultilayerItem({Key? key}) : super(key: key);

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

void navigateToInfo(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      reverseTransitionDuration: const Duration(milliseconds: 1000),
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: ((context, animation, secondaryAnimation) {
        return ItemsMultilayerInfo(animation: animation);
      }),
    ),
  );
}
