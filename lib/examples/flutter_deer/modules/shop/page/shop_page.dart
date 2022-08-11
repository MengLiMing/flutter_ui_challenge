import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/settings/setting_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              NavigatorUtils.push(context, SettingRouter.setting);
            },
            icon: Container(
                padding: const EdgeInsets.only(right: 5),
                width: 42,
                height: 44,
                alignment: Alignment.center,
                child: const LoadAssetImage('shop/setting',
                    width: 24, height: 24)),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
