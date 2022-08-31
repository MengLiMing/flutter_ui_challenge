import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_config_model/shop_config_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/common_dialog.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ShopConfigPayment extends StatefulWidget {
  final List<ShopPaymentStyle> payments;

  const ShopConfigPayment({
    Key? key,
    required this.payments,
  }) : super(key: key);

  @override
  State<ShopConfigPayment> createState() => _ShopConfigPaymentState();
}

class _ShopConfigPaymentState extends State<ShopConfigPayment> {
  late Set<ShopPaymentStyle> selectedValue;

  @override
  void initState() {
    super.initState();

    selectedValue = Set.from(widget.payments);
    selectedValue.add(ShopPaymentStyle.online);
  }

  void selected(ShopPaymentStyle style) {
    if (style == ShopPaymentStyle.online && selectedValue.contains(style)) {
      Toast.show('线上支付为必选项');
      return;
    }
    if (selectedValue.contains(style)) {
      selectedValue.remove(style);
    } else {
      selectedValue.add(style);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
        title: '支付方式(多选)',
        children: [
          const SizedBox(height: 8),
          ...ShopPaymentStyle.values.map((e) => _item(e)),
          const SizedBox(height: 8),
        ],
        onEnsure: () {
          final result = List<ShopPaymentStyle>.from(selectedValue);
          result.sort((l, r) => l.index - r.index);
          NavigatorUtils.pop(context, result: result);
        });
  }

  Widget _item(ShopPaymentStyle style) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => selected(style),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 42.fit,
        child: Row(
          children: [
            Expanded(
              child: Text(style.title),
            ),
            LoadAssetImage(
              selectedValue.contains(style) ? 'shop/xz' : 'shop/xztm',
              width: 16.0,
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
