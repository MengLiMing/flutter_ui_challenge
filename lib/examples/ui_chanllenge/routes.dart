import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/curves/curves_page.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/custom_slider/custom_slider_page.dart';

Map<String, WidgetBuilder> routes = {
  CustomSliderPage.route: (context) => CustomSliderPage(),
  CurvesPage.route: (context) => const CurvesPage(),
};
