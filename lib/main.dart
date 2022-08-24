import 'package:flutter/material.dart';
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
}
