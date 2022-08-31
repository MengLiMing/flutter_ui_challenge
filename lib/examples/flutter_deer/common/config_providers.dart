import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProviders {
  static final configInit = FutureProvider.autoDispose<void>((ref) async {
    final result = await Future.wait<dynamic>(
      [
        SharedPreferences.getInstance(),
      ],
    );

    DeerStorage.sp = result[0];

    return;
  });

  static final config =
      StateNotifierProvider<AppConfigStateNotifier, AppConfigState>((ref) {
    return AppConfigStateNotifier(
      AppConfigState(
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

class AppConfigStateNotifier extends StateNotifier<AppConfigState> {
  AppConfigStateNotifier(AppConfigState config) : super(config);

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
class AppConfigState extends Equatable {
  final bool hadShowGuide;
  final ThemeMode themeMode;

  /// 调试相关

  const AppConfigState({
    required this.hadShowGuide,
    required this.themeMode,
  });

  AppConfigState copyWith({
    bool? hadShowGuide,
    ThemeMode? themeMode,
  }) {
    return AppConfigState(
      hadShowGuide: hadShowGuide ?? this.hadShowGuide,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [hadShowGuide, themeMode];
}
