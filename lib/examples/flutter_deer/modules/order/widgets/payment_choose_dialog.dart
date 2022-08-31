import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/common_dialog.dart';
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
    return CommonDialog(
      title: '收款方式',
      children: [
        const SizedBox(height: 8),
        ValueListenableBuilder<PaymentType>(
          valueListenable: chooseType,
          builder: (context, value, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: PaymentType.values
                  .map(
                    (e) => _PaymentChooseItem(
                      key: ValueKey(e),
                      currentType: e,
                      chooseType: value,
                      onTap: (paymentType) => chooseType.value = paymentType,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
      onEnsure: () {
        NavigatorUtils.pop(context);
        ServicesBinding.instance.addPostFrameCallback(
          (timeStamp) {
            handler(chooseType.value);
          },
        );
      },
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
              visible: isSelected,
              child: LoadAssetImage(
                'order/ic_check',
                color: color,
                width: 14,
                height: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
