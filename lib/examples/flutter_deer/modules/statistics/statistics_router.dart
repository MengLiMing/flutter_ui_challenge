import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/page/statistics_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class StatisticsRouter extends ModularRouterProvider {
  static const statistics = '/statistics';

  @override
  void initRouter(FluroRouter router) {
    router.define(statistics, handler: Handler(handlerFunc: (context, _) {
      return const StatisticsPage();
    }));
  }
}
