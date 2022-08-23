import 'package:fluro/fluro.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_capital_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_record_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class ShopRouter extends ModularRouterProvider {
  static const shop = '/shop';

  /// 账户流水
  static const record = '/shop/record';

  /// 资金管理
  static const capital = '/shop/capital';

  @override
  void initRouter(FluroRouter router) {
    router.define(shop, handler: Handler(handlerFunc: (context, _) {
      return const ShopPage();
    }));

    router.define(record, handler: Handler(handlerFunc: (context, _) {
      return const ShopRecordPage();
    }));

    router.define(capital, handler: Handler(handlerFunc: (context, _) {
      return const ShopCapitalPage();
    }));
  }
}
