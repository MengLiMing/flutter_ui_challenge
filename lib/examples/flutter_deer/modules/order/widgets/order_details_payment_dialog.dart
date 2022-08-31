import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

final _paymentProvider = StateProvider<PaymentType>((ref) => PaymentType.none);

class OrderDetailsPaymentDialog extends ConsumerWidget {
  final ValueChanged<PaymentType> handler;

  const OrderDetailsPaymentDialog({
    Key? key,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 400, maxHeight: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 52,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Text('收款方式', style: TextStyles.textBold18),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 48,
                    child: CloseButton(color: Colours.textGray),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final paymentType = PaymentType.values[index];
                  return _PaymentItem(
                    key: ValueKey(paymentType),
                    paymentType: paymentType,
                  );
                },
                itemCount: PaymentType.values.length,
              ),
            ),
            SafeArea(
              child: MaterialButton(
                color: Colours.appMain,
                elevation: 0,
                minWidth: double.infinity,
                height: 50,
                onPressed: () {
                  handler(ref.read(_paymentProvider));
                  NavigatorUtils.pop(context);
                },
                child: const Text(
                  '确定',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PaymentItem extends ConsumerWidget {
  final PaymentType paymentType;

  const _PaymentItem({
    Key? key,
    required this.paymentType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(_paymentProvider) == paymentType;
    final color = isSelected ? Colours.appMain : Colours.text;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => ref.read(_paymentProvider.state).state = paymentType,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Text(paymentType.desc),
                ),
                Visibility(
                  visible: isSelected,
                  child: LoadAssetImage(
                    'order/ic_check',
                    color: color,
                    width: 14,
                    height: 14,
                  ),
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
