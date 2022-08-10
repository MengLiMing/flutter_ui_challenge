import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class CustomBackButton extends StatelessWidget {
  final double width;
  final double height;

  final VoidCallback? onTap;

  const CustomBackButton({
    Key? key,
    this.width = 44,
    this.height = 44,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ?? () => NavigatorUtils.pop(context),
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        child: const LoadAssetImage(
          'ic_back_black',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
