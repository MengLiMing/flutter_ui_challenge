import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/deer_app.dart';

final mainAppProvider = StateProvider<Widget>((ref) {
  return DeerApp();
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          return ref.watch(mainAppProvider);
        },
      ),
    ),
  );
  if (Platform.isAndroid) {
    //透明沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
  }
}
