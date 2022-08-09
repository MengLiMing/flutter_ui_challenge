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
          const Duration(seconds: 1),
        ),
      ],
    );

    DeerStorage.sp = result[0];

    return;
  });

  static final config = StateNotifierProvider<AppConfigState, AppConfig>((ref) {
    return AppConfigState(
      AppConfig(
        hadShowGuide: DeerStorage.hadShowGuide,
        themeMode: DeerStorage.themeMode,
      ),
    );
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

  set hadShowGuide(bool value) {
    DeerStorage.hadShowGuide = value;
    state = state.copyWith(hadShowGuide: value);
  }

  /// 修改主题模式
  void changeDarkMode(ThemeMode mode) {
    DeerStorage.themeMode = mode;

    state = state.copyWith(themeMode: mode);
  }
}

@immutable
class AppConfig extends Equatable {
  final bool hadShowGuide;
  final ThemeMode themeMode;

  const AppConfig({
    required this.hadShowGuide,
    required this.themeMode,
  });

  AppConfig copyWith({
    bool? hadShowGuide,
    ThemeMode? themeMode,
  }) {
    return AppConfig(
      hadShowGuide: hadShowGuide ?? this.hadShowGuide,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [hadShowGuide, themeMode];
}
