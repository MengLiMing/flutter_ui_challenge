import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';

class DeerTheme {
  static ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
      errorColor: isDarkMode ? Colours.darkRed : Colours.red,
      primaryColor: isDarkMode ? Colours.darkAppMain : Colours.appMain,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        secondary: isDarkMode ? Colours.darkAppMain : Colours.appMain,
      ),
      //指示器颜色
      indicatorColor: isDarkMode ? Colours.darkAppMain : Colours.appMain,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode ? Colours.darkBgColor : Colors.white,
      // 主要用于Material背景色
      canvasColor: isDarkMode ? Colours.darkMaterialBg : Colors.white,
      // 文字选择色
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colours.appMain.withAlpha(70),
        selectionHandleColor: Colours.appMain,
        cursorColor: Colours.appMain,
      ),
      textTheme: TextTheme(
        // TextField输入文字颜色
        subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
        // Text文字样式
        bodyText2: isDarkMode ? TextStyles.textDark : TextStyles.text,
        subtitle2:
            isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        elevation: 0.5,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        backgroundColor: isDarkMode ? Colours.darkBgColor : Colors.white,
        shadowColor: isDarkMode ? Colors.transparent : Colors.black45,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        toolbarHeight: 44,
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      dividerTheme: DividerThemeData(
        color: isDarkMode ? Colours.darkLine : Colours.line,
        space: 0.6,
        thickness: 0.6,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      visualDensity: VisualDensity
          .standard, // https://github.com/flutter/flutter/issues/77142
    );
  }
}
