import 'dart:math';

import 'package:flutter/material.dart';

class RandomUtil {
  static final random = Random();

  static Color get color => Color.fromRGBO(
      random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);

  static int number(int max) => random.nextInt(max);
}
