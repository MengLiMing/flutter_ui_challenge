import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/flutter_challenge_page.dart';

final mainAppProvider = StateProvider<Widget>((ref) {
  return const FlutterChallengeApp();
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
