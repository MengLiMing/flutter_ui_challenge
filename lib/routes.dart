import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/curves/curves_page.dart';
import 'package:flutter_ui_challenge/examples/custom_slider/custom_slider_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/deer_app.dart';

Map<String, WidgetBuilder> routes = {
  CustomSliderPage.route: (context) => CustomSliderPage(),
  CurvesPage.route: (context) => const CurvesPage(),
  DeerApp.route: (context) => DeerApp(),
};
