import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/settings/setting_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_actions.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_header.dart';
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
              child: const LoadAssetImage(
                'shop/setting',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: ShopHeader(),
            ),
            const SliverToBoxAdapter(child: Divider()),
            SliverToBoxAdapter(child: sectionTitle('账户', top: 24)),
            ShopActions(actions: [
              ShopAction(title: '账户流水', image: 'shop/zhls', onTap: () {}),
              ShopAction(title: '资金管理', image: 'shop/zjgl', onTap: () {}),
              ShopAction(title: '提现账号', image: 'shop/txzh', onTap: () {})
            ]),
            const SliverToBoxAdapter(child: Divider()),
            SliverToBoxAdapter(child: sectionTitle('店铺', top: 24)),
            ShopActions(actions: [
              ShopAction(title: '店铺设置', image: 'shop/dpsz', onTap: () {}),
            ]),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(
    String title, {
    double top = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
