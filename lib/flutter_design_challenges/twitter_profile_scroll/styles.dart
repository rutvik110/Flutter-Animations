import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Used for all animations in the  app
class Times {
  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 700);
  static const slower = Duration(milliseconds: 1000);
}

class Sizes {
  static double hitScale = 1;
  static double get hit => 40 * hitScale;
}

class IconSizes {
  static const double scale = 1;
  static const double med = 24;
}

class Insets {
  static double scale = 1;
  static double offsetScale = 1;
  // Regular paddings
  // static double get xs => 4 * scale;
  static double get sm => 5 * scale;
  static double get med => 10 * scale;
  static double get lg => 20 * scale;
  // static double get xl => 32 * scale;
  // Offset, used for the edge of the window, or to separate large sections in the app
  static double get offset => 40 * offsetScale;
}

class Corners {
  static const double sm = 8;
  static const BorderRadius smBorderRadius = BorderRadius.all(smRadius);
  static const Radius smRadius = Radius.circular(sm);

  static const double med = 12;
  static const BorderRadius medBorderRadius = BorderRadius.all(medRadius);
  static const Radius medRadius = Radius.circular(med);

  static const double lg = 16;
  static const BorderRadius lgBorderRadius = BorderRadius.all(lgRadius);
  static const Radius lgRadius = Radius.circular(lg);

  static const double extralg = 20;
  static const BorderRadius extralgBorderRadius =
      BorderRadius.all(extralgRadius);
  static const Radius extralgRadius = Radius.circular(extralg);
}

class Strokes {
  static const double thin = 1;
  static const double thick = 4;
}

class Elevations {
  static const double sm = 2;
  static const double med = 4;
  static const double lg = 8;
}

class Shadows {
  static List<BoxShadow> get universal => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.15),
            spreadRadius: 0,
            blurRadius: 10),
      ];
  static List<BoxShadow> get small => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.15),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1)),
      ];
}
