import 'package:fluro/fluro.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/goods_route.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/common_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/login/login_route.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/order_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/settings/setting_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/statistics_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/not_found_page.dart';

abstract class ModularRouterProvider {
  void initRouter(FluroRouter router);
}

class DeerRouters {
  static final FluroRouter router = FluroRouter();

  static final List<ModularRouterProvider> _listRouters = [];

  static void initRoutes() {
    /// 配置错误页面
    router.notFoundHandler = Handler(handlerFunc: (context, params) {
      return const NotFoundPage();
    });

    _listRouters.clear();

    /// 配置路由
    _listRouters.add(CommonRouter());
    _listRouters.add(LoginRouter());
    _listRouters.add(GoodsRouter());
    _listRouters.add(OrderRouter());
    _listRouters.add(StatisticsRouter());
    _listRouters.add(ShopRouter());
    _listRouters.add(SettingRouter());

    for (final element in _listRouters) {
      element.initRouter(router);
    }
  }
}
