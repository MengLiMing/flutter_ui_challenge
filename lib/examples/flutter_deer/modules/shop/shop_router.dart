import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_add_withdraw_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_capital_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_info_choose_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_record_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_withdraw_change_pwd_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_withdraw_choose_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_withdraw_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_withdraw_pwd_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';

class ShopRouter extends ModularRouterProvider {
  static const shop = '/shop';

  /// 账户流水
  static const record = '/shop/record';

  /// 资金管理
  static const capital = '/shop/capital';

  /// 提现
  static const withdraw = '/shop/withdraw';

  /// 添加账号
  static const withdrawAdd = '/shop/withdraw/add';

  /// 选择账号
  static const withdrawChoose = '/shop/withdraw/choose';

  /// 开户城市 style:0 /银行名称 style:1 /支行名称style:2
  static const chooseInfo = '/shop/city';

  /// 提现密码
  static const withdrawPwd = '/shop/withdraw/pwd';

  /// 修改密码
  static const changePwd = '/shop/withdraw/pwd/change';

  @override
  void initRouter(FluroRouter router) {
    router.define(shop, handler: Handler(handlerFunc: (context, _) {
      return const ShopPage();
    }));

    router.define(record, handler: Handler(handlerFunc: (context, _) {
      return const ShopRecordPage();
    }));

    router.define(capital, handler: Handler(handlerFunc: (context, _) {
      return const ShopCapitalPage();
    }));

    router.define(withdraw, handler: Handler(handlerFunc: (context, _) {
      return const ShopWithDrawPage();
    }));

    router.define(withdrawAdd, handler: Handler(handlerFunc: (context, _) {
      return const ShopAddWithdrawPage();
    }));

    router.define(withdrawChoose,
        handler: Handler(handlerFunc: (context, params) {
      ShopWithdrawAccountModel? model;
      if (context != null) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments is ShopWithdrawAccountModel) {
          model = arguments;
        }
      }
      return ShopWithdrawChoosePage(model: model);
    }));

    router.define(chooseInfo, handler: Handler(handlerFunc: (context, params) {
      final value = params['style']?.first ?? '0';
      final style = int.tryParse(value) ?? 0;
      return ShopInfoChoosePage(
        style: ShopInfoChooseStyle.values[style],
      );
    }));

    router.define(withdrawPwd, handler: Handler(handlerFunc: (_, __) {
      return const ShopWithdrawPwdPage();
    }));

    router.define(changePwd, handler: Handler(handlerFunc: (_, __) {
      return const ShopWithdrawChangePwdPage();
    }));
  }
}
