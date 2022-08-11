import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/common_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_interpector.dart';

class NavigatorUtils {
  static void push(
    BuildContext context,
    String path, {
    ValueChanged<dynamic>? resultCallback,
    bool replace = false,
    bool clearStack = false,
    Object? arguments,
    Map<String, dynamic /*String|Iterable<String>*/ >? parameters,
    TransitionType transtion = TransitionType.cupertino,
    NavigatorInterpector? interpector,
  }) {
    void push() {
      final String resultPath;
      if (parameters != null) {
        resultPath = Uri(path: path, queryParameters: parameters).toString();
      } else {
        resultPath = path;
      }
      DeerRouters.router
          .navigateTo(
        context,
        resultPath,
        replace: replace,
        clearStack: clearStack,
        routeSettings: RouteSettings(arguments: arguments),
        transition: transtion,
      )
          .then((value) {
        resultCallback?.call(value);
      });
    }

    if (interpector != null) {
      interpector.interpector(context, push);
      return;
    }
    push();
  }

  /// 需要登录
  static void pushNeedLogin(
    BuildContext context,
    String path, {
    ValueChanged<dynamic>? resultCallback,
    bool replace = false,
    bool clearStack = false,
    Object? arguments,
    Map<String, dynamic /*String|Iterable<String>*/ >? parameters,
    TransitionType transtion = TransitionType.cupertino,
    NavigatorInterpector? interpector,
  }) {
    push(
      context,
      path,
      resultCallback: resultCallback,
      replace: replace,
      clearStack: clearStack,
      parameters: parameters,
      arguments: arguments,
      transtion: transtion,
      interpector: LoginInterpector()..next = interpector,
    );
  }

  static void pop(BuildContext context, {Object? result}) {
    unfocus();
    DeerRouters.router.pop(context, result);
  }

  static void popTo(BuildContext context, String routeName) {
    unfocus();
    Navigator.of(context).popUntil((route) => route.settings.name == routeName);
  }

  static void popToRoot(BuildContext context) {
    unfocus();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static void pushToWeb(BuildContext context, String title, String url) {
    push(context, CommonRouter.webView, parameters: {
      'title': Uri.encodeComponent(title),
      'url': Uri.encodeComponent(url),
    });
  }

  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
