import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_witdraw_add_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_withdraw_account_type_choose.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_edit_scroll_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class ShopAddWithdrawPage extends ConsumerStatefulWidget {
  const ShopAddWithdrawPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopAddWithdrawPage> createState() =>
      _ShopAddWithdrawPageState();
}

class _ShopAddWithdrawPageState extends ConsumerState<ShopAddWithdrawPage>
    with ShopWithdrawAddProviders {
  void accountTypeChoose() {
    DialogUtils.show(context, builder: (context) {
      return ShopWithdrawAccontTypeChoose();
    }).then((value) {
      if (value is ShopAccontType) {
        ref
            .read(manager.state)
            .update((state) => state.copyWith(accontType: value));
      }
    });
  }

  void cityChoose() {
    NavigatorUtils.push(context, ShopRouter.city, resultCallback: (city) {
      if (city is String && city.isNotEmpty) {
        ref.read(manager.state).update((state) => state.copyWith(city: city));
      }
    });
  }

  void bankNameChoose() {}

  void brankNameChoose() {}
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(manager);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: const [
            CustomBackButton(),
            Text('添加账号'),
          ],
        ),
      ),
      body: MyEditScrollView(
        bottomHeight: 16 + max(ScreenUtils.bottomPadding, 8) + 44,
        bottom: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
            bottom: max(ScreenUtils.bottomPadding, 8),
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final value = ref.watch(canCommit);
              return MaterialButton(
                color: value ? Colours.appMain : Colours.buttonDisabled,
                minWidth: double.infinity,
                elevation: 0,
                height: 44,
                onPressed: () {
                  if (value == false) return;
                  commitAction();
                },
                child: const Text('点击', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ),
        padding: const EdgeInsets.only(left: 16),
        children: [
          _selectedItem(
              '账号类型', '请选择账号类型', data.accontType.title, accountTypeChoose),
          if (data.accontType == ShopAccontType.wechat)
            _hintText('绑定本机当前登录的微信号')
          else ...[
            _editInfo('持卡人', '填写您的真实姓名', (value) {
              ref.read(manager.state).update(
                    (state) => state.copyWith(name: value ?? ''),
                  );
            }),
            _editInfo('银行卡号', '填写银行卡号', (value) {
              ref.read(manager.state).update(
                    (state) => state.copyWith(cardNumber: value ?? ''),
                  );
            }),
            _selectedItem('开户地', '选择开户城市', data.bankEditModel.city, cityChoose),
            _selectedItem(
                '银行名称', '选择开户银行', data.bankEditModel.bankName, bankNameChoose),
            _selectedItem('支行名称', '选择开户支行', data.bankEditModel.branchName,
                bankNameChoose),
            _hintText('绑定持卡人本人的银行卡'),
          ],
        ],
      ),
    );
  }

  Widget _editInfo(String title, String hint, ValueChanged<String?> onChange) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 72,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(title),
            ),
            Expanded(
              child: SimpleTextField(
                hasLine: false,
                hintText: hint,
                hintStyle: const TextStyle(color: Colours.textGrayC),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _hintText(String text) {
    return Container(
      padding: const EdgeInsets.only(top: 8, right: 16),
      child: Text(
        text,
        style: const TextStyle(color: Colours.textGray, fontSize: 12),
      ),
    );
  }

  Widget _selectedItem(
      String title, String hint, String content, VoidCallback onTap) {
    final showHint = content.isEmpty;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(title),
              ),
              Expanded(
                child: showHint
                    ? Text(
                        hint,
                        style: const TextStyle(color: Colours.textGrayC),
                      )
                    : Text(content),
              ),
              LoadAssetImage('ic_arrow_right', height: 16.fit, width: 16.fit),
              const SizedBox(width: 16),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  void commitAction() {
    final model = ref.read(manager);
    final ShopWithdrawAccountModel result;
    if (model.accontType == ShopAccontType.wechat) {
      result = ShopWithdrawAccountModel(
        title: '微信',
        desc: RandomUtil.number(1000).toString(),
        type: model.accontType,
      );
    } else {
      result = ShopWithdrawAccountModel(
        title: model.bankEditModel.bankName,
        desc: model.bankEditModel.cardNumber,
        type: model.accontType,
      );
    }

    NavigatorUtils.pop(context, result: result);
  }
}
