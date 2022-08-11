import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/deer_app.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/flutter_challenge_page.dart';
import 'package:flutter_ui_challenge/main.dart';

class ChangeAppPage extends ConsumerWidget {
  const ChangeAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('切换App'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          _changleApp(ref),
          _deerApp(ref),
        ],
      ),
    );
  }

  Widget _changleApp(WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          ref.read(mainAppProvider.state).state = const FlutterChallengeApp();
        },
        child: _gridContainer(
          const Text('UI Chanllenge'),
        ));
  }

  Widget _deerApp(WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(mainAppProvider.state).state = DeerApp();
      },
      child: _gridContainer(const LoadAssetImage(
        'logo',
        width: 80,
        height: 80,
      )),
    );
  }

  Widget _gridContainer(Widget child) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 2, offset: Offset.zero),
        ],
      ),
      child: child,
    );
  }
}
