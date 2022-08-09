import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/deer_main_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class CommonRouter extends ModularRouterProvider {
  static String main = '/main';

  @override
  void initRouter(FluroRouter router) {
    router.define(main, handler: Handler(handlerFunc: (context, params) {
      return const DeerMainPage();
    }));
  }
}
