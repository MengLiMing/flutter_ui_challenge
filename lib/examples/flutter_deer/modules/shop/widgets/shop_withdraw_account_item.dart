import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ShopWithdrawAccountItem extends StatelessWidget {
  final ShopWithdrawAccountModel model;

  const ShopWithdrawAccountItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  List<Color> get gradientColors => model.isBank
      ? const [
          Color(0xFF57C4FA),
          Color(0xFF4688FA),
        ]
      : const [
          Color(0xFF40E6AE),
          Color(0xFF2DE062),
        ];

  Color get shadowColor =>
      model.isBank ? const Color(0xFF5793FA) : const Color(0xFF4EE07A);

  @override
  Widget build(BuildContext context) {
    final iconWidth = 44.fit;
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Container(
        margin: EdgeInsets.only(left: 24.fit, right: 24.fit, top: 16.fit),
        padding: EdgeInsets.all(24.fit),
        height: 136.fit,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.fit)),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            )
          ],
          gradient: LinearGradient(colors: gradientColors),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: iconWidth,
                  height: iconWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(iconWidth / 2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: LoadAssetImage(
                    model.isBank ? 'account/yhk' : 'account/wechat',
                    width: 24.fit,
                    height: 24.fit,
                  ),
                ),
                SizedBox(width: 8.fit),
                Expanded(
                  child: SizedBox(
                    height: iconWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.title, style: const TextStyle(fontSize: 18)),
                        Expanded(child: Container()),
                        Text(model.desc, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (model.isBank)
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: iconWidth + 8.fit),
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    '**** **** **** 1111',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
