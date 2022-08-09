import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/login/page/code_login_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/login/page/login_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class LoginRouter extends ModularRouterProvider {
  static const login = '/login';
  static const register = '/login/register';
  static const codeLogin = '/login/code';

  @override
  void initRouter(FluroRouter router) {
    router.define(login, handler: Handler(handlerFunc: (context, param) {
      return const LoginPage();
    }));

    router.define(codeLogin, handler: Handler(handlerFunc: (context, param) {
      return const CodeLoginPage();
    }));
  }
}
