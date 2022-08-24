import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/number_key_borad.dart';

class ShopPwdDialog extends StatefulWidget {
  const ShopPwdDialog({Key? key}) : super(key: key);

  @override
  State<ShopPwdDialog> createState() => _ShopPwdDialogState();
}

class _ShopPwdDialogState extends State<ShopPwdDialog> {
  ValueNotifier<List<int>> inputPwd = ValueNotifier([]);

  final maxLength = 6;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16.fit, width: double.infinity),
                  const Text('输入提现密码', style: TextStyles.textBold16),
                  SizedBox(height: 40.fit),
                  codeView(),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 32,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Text(
                            '忘记密码?',
                            style: TextStyle(
                              color: Colours.appMain,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 68.fit),
                  NumberKeyboard(
                    onDelete: () {
                      List<int> value = List.from(inputPwd.value);
                      if (value.isNotEmpty) {
                        value.removeLast();
                      }
                      inputPwd.value = value;
                    },
                    onTapNumber: (number) {
                      if (inputPwd.value.length < maxLength) {
                        inputPwd.value = [...inputPwd.value, number];
                      }
                      if (inputPwd.value.length == maxLength) {
                        final result = inputPwd.value.join();
                        NavigatorUtils.pop(context, result: result);
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget codeView() {
    return Container(
      margin: EdgeInsets.only(left: 16.fit, right: 16.fit),
      height: 40.fit,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colours.textGrayC, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: ValueListenableBuilder<List<int>>(
          valueListenable: inputPwd,
          builder: (context, value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < maxLength; i++) ...[
                  if (i != 0)
                    Container(
                      width: 1,
                      height: double.infinity,
                      color: Colours.textGrayC,
                    ),
                  if (value.length > i)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Container(),
                    )
                ]
              ],
            );
          }),
    );
  }
}
