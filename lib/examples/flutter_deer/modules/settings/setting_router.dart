import 'package:fluro/fluro.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/settings/page/setting_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class SettingRouter extends ModularRouterProvider {
  static const setting = '/setting';

  @override
  void initRouter(FluroRouter router) {
    router.define(setting, handler: Handler(handlerFunc: (context, _) {
      return const SettingPage();
    }));
  }
}
