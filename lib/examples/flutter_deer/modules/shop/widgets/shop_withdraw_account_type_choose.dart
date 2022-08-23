import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';

class ShopWithdrawAccontTypeChoose extends StatelessWidget {
  const ShopWithdrawAccontTypeChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 56),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24),
            Text(
              '账号类型',
              style: TextStyles.textBold18,
            ),
            SizedBox(height: 16),
            for (final type in ShopAccontType.values) ...[
              const Divider(),
              InkWell(
                onTap: () => NavigatorUtils.pop(context, result: type),
                child: Container(
                  height: 42,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    type.title,
                    style: const TextStyle(color: Colours.appMain),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
