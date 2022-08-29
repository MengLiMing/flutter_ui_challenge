import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/page/statistics_info_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/page/statistics_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class StatisticsRouter extends ModularRouterProvider {
  static const statistics = '/statistics';

  static const info = '/statistics/info';

  @override
  void initRouter(FluroRouter router) {
    router.define(statistics, handler: Handler(handlerFunc: (context, _) {
      return const StatisticsPage();
    }));

    router.define(info, handler: Handler(handlerFunc: (context, params) {
      final style = int.tryParse(params['style']?.first as String) ?? 0;
      return StatisticsInfoPage(
        style: StatisticsInfoStyle.values[style],
      );
    }));
  }
}
