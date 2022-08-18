import 'package:fluro/fluro.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/page/goods_edit_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/page/goods_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class GoodsRouter extends ModularRouterProvider {
  static const goods = '/goods';
  static const edit = '/goods/edit';
  @override
  void initRouter(FluroRouter router) {
    router.define(goods, handler: Handler(handlerFunc: (context, _) {
      return const GoodsPage();
    }));

    router.define(edit, handler: Handler(handlerFunc: (context, _) {
      return const GoodsEditPage();
    }));
  }
}
