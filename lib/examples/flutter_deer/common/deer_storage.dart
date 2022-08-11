import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/constant.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeerStorage {
  static late SharedPreferences sp;

  /// 用户信息
  static DeerUserInfo? get userInfo {
    final value = sp.get(StorageKey.userInfo);
    if (value != null) {
      final userJson = jsonDecode(value as String) as Map<String, dynamic>;

      return DeerUserInfo.fromJson(userJson);
    }
    return null;
  }

  static set userInfo(DeerUserInfo? value) {
    if (value == null) {
      sp.remove(StorageKey.userInfo);
      return;
    }
    final jsonString = jsonEncode(value.toJson());
    sp.setString(StorageKey.userInfo, jsonString);
  }

  // 是否登录
  static bool get isLogin => userInfo != null;

  /// 之前登录人的手机号 - 用于下次填写使用
  static String get phone => sp.getString(StorageKey.phone) ?? '';
  static set phone(String value) => sp.setString(StorageKey.phone, value);

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
