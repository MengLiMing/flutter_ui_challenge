import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_search_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class OrderRouter extends ModularRouterProvider {
  static const order = '/order';
  static const search = '/order/search';

  @override
  void initRouter(FluroRouter router) {
    router.define(order, handler: Handler(handlerFunc: (context, _) {
      return const OrderPage();
    }));

    router.define(search, handler: Handler(handlerFunc: (context, _) {
      return const OrderSearchPage();
    }));
  }
}
