import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_pwd_sms_dialog.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/list_click_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_scroll_view.dart';

class ShopWithdrawPwdPage extends StatelessWidget {
  const ShopWithdrawPwdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('提现密码'),
      ),
      body: MyScrollView(
        children: [
          ListClickItem(
              title: '修改密码',
              onTap: () {
                NavigatorUtils.push(context, ShopRouter.changePwd);
              }),
          ListClickItem(title: '忘记密码', onTap: () => forgetPwd(context)),
        ],
      ),
    );
  }

  void forgetPwd(BuildContext context) {
    DialogUtils.show(context, builder: (context) {
      return const ShopPwdSmsDialog();
    }).then((code) {
      if (code == null) return;
      Toast.show('验证码：$code');
    });
  }
}
