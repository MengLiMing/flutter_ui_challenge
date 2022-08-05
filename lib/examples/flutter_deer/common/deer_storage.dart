import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeerStorage {
  static late SharedPreferences sp;

  /// 用户是否登录
  static bool get isLogin => sp.getBool(StorageKey.isLogin) ?? false;
  static set isLogin(bool value) => sp.setBool(StorageKey.isLogin, value);

  /// 是否展示过引导页
  static bool get hadShowGuide => sp.getBool(StorageKey.hadShowGuide) ?? false;
  static set hadShowGuide(bool value) =>
      sp.setBool(StorageKey.hadShowGuide, value);

  /// 系统主题
  static ThemeMode get themeMode {
    final theme = sp.getString(StorageKey.themeMode);
    switch (theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  static set themeMode(ThemeMode mode) {
    String themeString;
    switch (mode) {
      case ThemeMode.dark:
        themeString = 'Dark';
        break;
      case ThemeMode.light:
        themeString = 'Light';
        break;
      default:
        themeString = 'System';
    }
    sp.setString(StorageKey.themeMode, themeString);
  }
}
