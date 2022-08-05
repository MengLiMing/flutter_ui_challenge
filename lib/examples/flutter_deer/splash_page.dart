import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/config_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  final List<String> _guideList = [
    'app_start_1',
    'app_start_2',
    'app_start_3',
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1)).then((_) {
      ref.read(ConfigProviders.config.notifier).showedGuide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: LoadAssetImage(
          _guideList[0],
          fit: BoxFit.cover,
          format: ImageFormat.webp,
        ),
      ),
    );
  }
}
