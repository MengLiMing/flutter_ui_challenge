import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/settings/setting_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_actions.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_header.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ShopHeader(),
          ),
          line(),
          SliverToBoxAdapter(child: sectionTitle('账户', top: 24)),
          ShopActions(actions: [
            ShopAction(
                title: '账户流水',
                image: 'shop/zhls',
                onTap: () {
                  NavigatorUtils.push(context, ShopRouter.record);
                }),
            ShopAction(
                title: '资金管理',
                image: 'shop/zjgl',
                onTap: () {
                  NavigatorUtils.push(context, ShopRouter.capital);
                }),
            ShopAction(
                title: '提现账号',
                image: 'shop/txzh',
                onTap: () {
                  NavigatorUtils.push(context, ShopRouter.account);
                })
          ]),
          line(),
          SliverToBoxAdapter(child: sectionTitle('店铺', top: 24)),
          ShopActions(actions: [
            ShopAction(
                title: '店铺设置',
                image: 'shop/dpsz',
                onTap: () {
                  NavigatorUtils.push(context, ShopRouter.config);
                }),
          ]),
        ],
      ),
    );
  }

  Widget line() {
    return const SliverPadding(
      padding: EdgeInsets.only(left: 16),
      sliver: SliverToBoxAdapter(
        child: Divider(),
      ),
    );
  }

  Widget sectionTitle(
    String title, {
    double top = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom, left: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
