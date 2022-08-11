import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/config_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class DeerGuidePage extends ConsumerStatefulWidget {
  const DeerGuidePage({Key? key}) : super(key: key);

  @override
  ConsumerState<DeerGuidePage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<DeerGuidePage> {
  final List<String> _guideList = [
    'app_start_1',
    'app_start_2',
    'app_start_3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const ClampingScrollPhysics(
            parent: RangeMaintainingScrollPhysics()),
        children: [
          for (int i = 0; i < _guideList.length; i++)
            if (i == _guideList.length - 1)
              GestureDetector(
                onTap: () {
                  ref.read(ConfigProviders.config.notifier).hadShowGuide = true;
                },
                child: SizedBox.expand(
                  child: LoadAssetImage(
                    _guideList[i],
                    fit: BoxFit.cover,
                    format: ImageFormat.webp,
                  ),
                ),
              )
            else
              SizedBox.expand(
                child: LoadAssetImage(
                  _guideList[i],
                  fit: BoxFit.cover,
                  format: ImageFormat.webp,
                ),
              ),
        ],
      ),
    );
  }
}
