import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/code_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/input_dialog.dart';

class ShopPwdSmsDialog extends StatefulWidget {
  const ShopPwdSmsDialog({Key? key}) : super(key: key);

  @override
  State<ShopPwdSmsDialog> createState() => _ShopPwdSmsDialogState();
}

class _ShopPwdSmsDialogState extends State<ShopPwdSmsDialog> {
  Timer? timer;

  final ValueNotifier<int> _countDown = ValueNotifier(0);

  int get countDown => _countDown.value;
  set countDown(int value) {
    _countDown.value = value;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void startTimer() {
    countDown = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      countDown -= 1;
      if (countDown == 0) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    countDown = 0;
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return InputDialog(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 48.fit),
        padding: EdgeInsets.symmetric(horizontal: 16.fit),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: double.infinity),
            SizedBox(height: 24.fit),
            const Text('短信验证',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.fit),
            const Text(
              '本次操作需短信验证，验证码会发送至您的注册手机 130 1100 0011',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.fit),
            SizedBox(
              height: 32.fit,
              width: 232.fit,
              child: CodeView(
                autofocus: false,
                autoUnfocus: false,
                length: 6,
                hadInputBuilder: (context, value, index) {
                  return _codeItem(true);
                },
                inputtingBuilder: (context, index) {
                  return _codeItem(false);
                },
                noInputBuilder: (context, index) {
                  return _codeItem(false);
                },
                spaceBuilder: (context, index) {
                  return SizedBox(width: 8.fit);
                },
                codeChanged: (pwd) {
                  if (pwd.length == 6) {
                    NavigatorUtils.pop(context, result: pwd);
                  }
                },
              ),
            ),
            SizedBox(height: 16.fit),
            const Divider(),
            Container(
              height: 50,
              alignment: Alignment.center,
              child: _sendButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendButton() {
    return ValueListenableBuilder(
        valueListenable: _countDown,
        builder: (context, value, _) {
          if (value == 0) {
            return TextButton(
              onPressed: startTimer,
              child: const Text(
                '获取验证码',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return Text(
              '已发送($value s)',
              style: const TextStyle(
                color: Colours.textGray,
                fontSize: 18,
              ),
            );
          }
        });
  }

  Widget _codeItem(bool hasValue) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.fit)),
        border: Border.all(color: Colours.textGrayC),
      ),
      child: hasValue
          ? Container(
              width: 8.fit,
              height: 8.fit,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4.fit))),
            )
          : null,
    );
  }
}
