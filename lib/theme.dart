import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  static const Map<TargetPlatform, PageTransitionsBuilder> _defaultBuilders = {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  };

  static ThemeData lightTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(builders: _defaultBuilders),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 44,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      shadowColor: Colors.black45,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );
}
