import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/curves/curves_page.dart';
import 'package:flutter_ui_challenge/pages/custom_slider/custom_slider_page.dart';

Map<String, WidgetBuilder> routes = {
  CustomSliderPage.route: (context) => CustomSliderPage(),
  CurvesPage.route: (context) => const CurvesPage(),
};
