import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

enum ShopWithdrawAccountStyle {
  normal,
  arrow,
  selected,
}

class ShopWithdrawAccount extends StatelessWidget {
  final ShopWithdrawAccountModel model;
  final ShopWithdrawAccountStyle style;

  const ShopWithdrawAccount({
    Key? key,
    required this.model,
    this.style = ShopWithdrawAccountStyle.arrow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 21.fit, bottom: 16.fit),
      child: Row(
        children: [
          LoadAssetImage(
            model.isBank ? 'account/yhk' : 'account/wechat',
            width: 24.fit,
          ),
          SizedBox(width: 16.fit),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title),
                SizedBox(height: 8.fit),
                Text(
                  model.desc,
                  style: const TextStyle(
                    color: Colours.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: style != ShopWithdrawAccountStyle.normal,
            child: style == ShopWithdrawAccountStyle.arrow
                ? LoadAssetImage('ic_arrow_right',
                    height: 16.fit, width: 16.fit)
                : const LoadAssetImage(
                    'account/selected',
                    height: 24.0,
                    width: 24.0,
                  ),
          ),
        ],
      ),
    );
  }
}
