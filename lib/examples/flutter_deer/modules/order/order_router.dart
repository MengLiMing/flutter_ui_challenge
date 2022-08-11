import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_detail_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_search_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_track_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_header_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/not_found_page.dart';

class OrderRouter extends ModularRouterProvider {
  static const order = '/order';
  static const search = '/order/search';
  static const details = 'order/details';
  static const track = 'order/track';

  @override
  void initRouter(FluroRouter router) {
    router.define(order, handler: Handler(handlerFunc: (context, _) {
      return ProviderScope(
        overrides:
            HeaderProviders.overrides, //状态使用的static， 避免打开两个orderpage 状态混乱
        child: const OrderPage(),
      );
    }));

    router.define(search, handler: Handler(handlerFunc: (context, _) {
      return const OrderSearchPage();
    }));

    router.define(details, handler: Handler(handlerFunc: (context, params) {
      final String? orderId = (context?.settings?.arguments as String?) ??
          (params['orderId']?.first as String?);
      if (orderId != null) {
        return OrderDetailPage(
          orderId: orderId,
        );
      } else {
        return const NotFoundPage();
      }
    }));

    router.define(track, handler: Handler(handlerFunc: (context, params) {
      final String? orderId = (context?.settings?.arguments as String?) ??
          (params['orderId']?.first as String?);
      if (orderId != null) {
        return OrderTrackPage(
          orderId: orderId,
        );
      } else {
        return const NotFoundPage();
      }
    }));
  }
}
