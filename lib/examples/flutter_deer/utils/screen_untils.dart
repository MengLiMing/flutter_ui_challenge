import 'package:flutter/material.dart';

class ScreenUtils {
  ScreenUtils._();

  static final _instance = ScreenUtils._();

  BuildContext? _context;

  static BuildContext get _currentContext => _instance._context!;

  static void config(BuildContext context) {
    _instance._context = context;
  }

  static MediaQueryData get mediaQuery => MediaQuery.of(_currentContext);

  static double get topPadding => mediaQuery.padding.top;

  static double get bottomPadding => mediaQuery.padding.bottom;

  static double get navBarHeight => 44;

  static double get width => mediaQuery.size.width;

  static double get height => mediaQuery.size.height;

  static double get keyboardHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .viewInsets
          .bottom;

  static double get scale {
    if (width > 0) {
      return width / 375;
    } else {
      return 1;
    }
  }
}

extension ScreenUtilsFit on num {
  double get fit => ((ScreenUtils.scale * this) * 10).roundToDouble() / 10;
}
