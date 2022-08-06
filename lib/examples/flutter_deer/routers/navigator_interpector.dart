import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/login/login_route.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';

typedef InterpectorNext = void Function();

abstract class NavigatorInterpector {
  /// 下一个拦截器
  NavigatorInterpector? next;

  void interpector(BuildContext context, InterpectorNext handler) {
    if (next == null) handler();
    next!.interpector(context, handler);
  }
}

class LoginInterpector with NavigatorInterpector {
  @override
  void interpector(BuildContext context, InterpectorNext handler) {
    /// 判断是否登录
    if (DeerStorage.isLogin) {
      handler();
      return;
    }
    NavigatorUtils.push(context, LoginRouter.login, resultCallback: (_) {
      if (DeerStorage.isLogin) {
        handler();
        return;
      }
    });
  }
}
