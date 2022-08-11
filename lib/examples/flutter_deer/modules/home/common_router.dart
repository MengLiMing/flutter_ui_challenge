import 'package:fluro/fluro.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/deer_main_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/web_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class CommonRouter extends ModularRouterProvider {
  static String main = '/main';

  static String webView = '/webView';

  @override
  void initRouter(FluroRouter router) {
    router.define(main, handler: Handler(handlerFunc: (context, params) {
      return const DeerMainPage();
    }));

    router.define(webView, handler: Handler(handlerFunc: (context, params) {
      final title = params['title']?.first as String;
      final url = params['url']?.first as String;
      return WebViewPage(title: title, url: url);
    }));
  }
}
