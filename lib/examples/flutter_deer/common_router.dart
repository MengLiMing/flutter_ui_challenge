import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/deer_home_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class CommonRouter extends ModularRouterProvider {
  static String home = '/home';

  @override
  void initRouter(FluroRouter router) {
    router.define(home, handler: Handler(handlerFunc: (context, params) {
      return DeerHomePage();
    }));
  }
}
