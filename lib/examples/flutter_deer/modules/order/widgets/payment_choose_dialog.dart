import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class PaymentChooseDialog extends StatelessWidget {
  final ValueChanged<PaymentType> handler;

  final ValueNotifier<PaymentType> chooseType = ValueNotifier(PaymentType.none);

  PaymentChooseDialog({
    Key? key,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 263, minWidth: 263),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 8),
              child: const Text('收款方式', style: TextStyles.textBold18),
            ),

            /// 选择区域
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 168),
              child: SingleChildScrollView(
                child: ValueListenableBuilder<PaymentType>(
                    valueListenable: chooseType,
                    builder: (context, value, _) {
                      return Column(
                        children: PaymentType.values
                            .map(
                              (e) => _PaymentChooseItem(
                                key: ValueKey(e),
                                currentType: e,
                                chooseType: value,
                                onTap: (paymentType) =>
                                    chooseType.value = paymentType,
                              ),
                            )
                            .toList(),
                      );
                    }),
              ),
            ),

            /// 确定取消按钮
            SizedBox(height: 8),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () => NavigatorUtils.pop(context),
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colours.textGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 0.8,
                  height: 50,
                  child: ColoredBox(color: Colours.line),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      NavigatorUtils.pop(context);
                      ServicesBinding.instance.addPostFrameCallback(
                        (timeStamp) {
                          handler(chooseType.value);
                        },
                      );
                    },
                    child: const Text(
                      '确定',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colours.appMain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentChooseItem extends StatelessWidget {
  final PaymentType currentType;
  final PaymentType chooseType;

  final ValueChanged<PaymentType> onTap;

  const _PaymentChooseItem({
    Key? key,
    required this.currentType,
    required this.chooseType,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = currentType == chooseType;
    final color = isSelected ? Colours.appMain : Colours.text;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(currentType),
      child: Container(
        height: 42,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentType.desc,
                style: TextStyle(fontSize: 14, color: color),
              ),
            ),
            Visibility(
              child: LoadAssetImage(
                'order/ic_check',
                color: color,
                width: 14,
                height: 14,
              ),
              visible: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

enum PaymentType {
  none,
  alipay,
  wechat,
  cash,
}

extension PaymentTypeExtension on PaymentType {
  String get desc => ['未付款', '支付宝', '微信', '现金'][index];
}
