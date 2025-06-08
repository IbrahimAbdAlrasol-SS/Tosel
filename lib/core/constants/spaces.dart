// lib/constants/spaces.dart

import 'package:flutter/widgets.dart';

class AppSpaces {
  static const  exSmall = 4.0;

  static const  small = 8.0;

  static const  medium = 16.0;

  static const  large = 24.0;

  static const  exLarge = 32.0;
  static const double none = 0;
    static const double xxs = 4.0;


  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: 24.0);

  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: 24.0);

  // for both horizontal and vertical
  static const EdgeInsets allSmall = EdgeInsets.all(8.0);
  static const EdgeInsets allMedium = EdgeInsets.all(16.0);
  static const EdgeInsets allLarge = EdgeInsets.all(24.0);
  static const double full = 100.0;

    static const BorderRadius noneRadius =
      BorderRadius.all(Radius.circular(none));
  static const BorderRadius xxsRadius = BorderRadius.all(Radius.circular(xxs));
  static const BorderRadius extraSmallRadius =
      BorderRadius.all(Radius.circular(exSmall));
  static const BorderRadius smallRadius =
      BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumRadius =
      BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeRadius =
      BorderRadius.all(Radius.circular(large));
  static const BorderRadius extraLargeRadius =
      BorderRadius.all(Radius.circular(exLarge));
  static const BorderRadius fullRadius =
      BorderRadius.all(Radius.circular(full));
  
}
