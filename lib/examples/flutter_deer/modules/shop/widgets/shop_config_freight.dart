import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_config_model/shop_config_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/common_dialog.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ShopConfigFreight extends StatefulWidget {
  final ShopFreightConfig config;

  const ShopConfigFreight({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<ShopConfigFreight> createState() => _ShopConfigFreightState();
}

class _ShopConfigFreightState extends State<ShopConfigFreight> {
  late ShopFreightConfig config;

  @override
  void initState() {
    super.initState();

    config = widget.config;
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
        title: '运费配置',
        children: [
          SizedBox(height: 8),
          ...ShopFreightConfig.values.map((e) => _item(e)),
          SizedBox(height: 8),
        ],
        onEnsure: () {
          NavigatorUtils.pop(context, result: config);
        });
  }

  Widget _item(ShopFreightConfig value) {
    final isSelected = config == value;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          config = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 42.fit,
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.title,
                style: TextStyle(
                  color: isSelected ? Colours.appMain : Colours.text,
                ),
              ),
            ),
            if (isSelected)
              const LoadAssetImage(
                'order/ic_check',
                width: 16.0,
                height: 16.0,
              ),
          ],
        ),
      ),
    );
  }
}
