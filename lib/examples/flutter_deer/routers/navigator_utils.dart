import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_interpector.dart';

class NavigatorUtils {
  static void push(
    BuildContext context,
    String path, {
    ValueChanged<dynamic>? resultCallback,
    bool replace = false,
    bool clearStack = false,
    Object? argument,
    TransitionType transtion = TransitionType.cupertino,
    NavigatorInterpector? interpector,
  }) {
    void push() {
      DeerRouters.router
          .navigateTo(
        context,
        path,
        replace: replace,
        clearStack: clearStack,
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
    Object? argument,
    TransitionType transtion = TransitionType.cupertino,
    NavigatorInterpector? interpector,
  }) {
    push(
      context,
      path,
      resultCallback: resultCallback,
      replace: replace,
      clearStack: clearStack,
      argument: argument,
      transtion: transtion,
      interpector: LoginInterpector()..next = interpector,
    );
  }

  static void pop(BuildContext context, {Object? result}) {
    unfocus();
    DeerRouters.router.pop(context, result);
  }

  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
