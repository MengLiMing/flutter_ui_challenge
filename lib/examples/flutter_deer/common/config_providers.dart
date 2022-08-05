import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProviders {
  static final configInit = FutureProvider<void>((ref) async {
    final result = await Future.wait<dynamic>(
      [
        SharedPreferences.getInstance(),
        Future.delayed(
          const Duration(seconds: 3),
        ),
      ],
    );

    DeerStorage.sp = result[0];

    return;
  });

  static final config = StateNotifierProvider<AppConfigState, AppConfig>((ref) {
    return AppConfigState(
      AppConfig(
        isLogin: DeerStorage.isLogin,
        hadShowGuide: DeerStorage.hadShowGuide,
        themeMode: DeerStorage.themeMode,
      ),
    );
  });

  static final isLogin = Provider<bool>((ref) {
    return ref.watch(config).isLogin;
  });

  static final hadShowGuide = Provider<bool>((ref) {
    return ref.watch(config).hadShowGuide;
  });

  static final themeMode = Provider<ThemeMode>((ref) {
    return ref.watch(config).themeMode;
  });
}

class AppConfigState extends StateNotifier<AppConfig> {
  AppConfigState(AppConfig config) : super(config);

  void loginSuccess() {
    DeerStorage.isLogin = true;

    state = state.copyWith(isLogin: true);
  }

  void showedGuide() {
    DeerStorage.hadShowGuide = true;
    state = state.copyWith(hadShowGuide: true);
  }

  /// 修改主题模式
  void changeDarkMode(ThemeMode mode) {
    DeerStorage.themeMode = mode;

    state = state.copyWith(themeMode: mode);
  }
}

@immutable
class AppConfig extends Equatable {
  final bool isLogin;
  final bool hadShowGuide;
  final ThemeMode themeMode;

  const AppConfig({
    required this.isLogin,
    required this.hadShowGuide,
    required this.themeMode,
  });

  AppConfig copyWith({
    bool? isLogin,
    bool? hadShowGuide,
    ThemeMode? themeMode,
  }) {
    return AppConfig(
      isLogin: isLogin ?? this.isLogin,
      hadShowGuide: hadShowGuide ?? this.hadShowGuide,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [
        isLogin,
        hadShowGuide,
        themeMode,
      ];
}
