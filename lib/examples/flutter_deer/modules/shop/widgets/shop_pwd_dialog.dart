import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_pwd_code_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
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
                            '密码不是666666',
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
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => NavigatorUtils.pop(context),
                  child: Container(
                    height: 48.fit,
                    width: 48.fit,
                    alignment: Alignment.center,
                    child: LoadAssetImage(
                      'goods/icon_dialog_close',
                      width: 16.fit,
                      height: 16.fit,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget codeView() {
    return Container(
      child: ValueListenableBuilder<List<int>>(
        valueListenable: inputPwd,
        builder: (context, value, _) {
          return ShopPwdCodeView(
            margin: EdgeInsets.only(left: 16.fit, right: 16.fit),
            radius: 4.fit,
            height: 40.fit,
            pwd: value,
          );
        },
      ),
    );
  }
}
