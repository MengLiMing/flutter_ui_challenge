import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';

class AlertView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onTap;

  const AlertView({
    Key? key,
    required this.title,
    required this.message,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: min(ScreenUtils.width * 0.8, 400),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                title,
                style: TextStyles.textBold18,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 14,
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyles.textSize16,
              ),
            ),
            const SizedBox(
              height: 0.8,
              width: double.infinity,
              child: ColoredBox(color: Colours.line),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      color: Colors.white,
                      onPressed: () => NavigatorUtils.pop(context),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colours.textGray, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                    height: double.infinity,
                    child: ColoredBox(color: Colours.line),
                  ),
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      color: Colors.white,
                      onPressed: () {
                        NavigatorUtils.pop(context);
                        onTap();
                      },
                      child: const Text(
                        '确定',
                        style: TextStyle(color: Colours.appMain, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
