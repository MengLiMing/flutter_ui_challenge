import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_pwd_code_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/number_key_borad.dart';

class ShopWithdrawChangePwdPage extends StatefulWidget {
  const ShopWithdrawChangePwdPage({Key? key}) : super(key: key);

  @override
  State<ShopWithdrawChangePwdPage> createState() =>
      _ShopWithdrawChangePwdPageState();
}

class _ShopWithdrawChangePwdPageState extends State<ShopWithdrawChangePwdPage> {
  List<int> inputPwd = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: const [
            CustomBackButton(),
            Text('修改提现密码'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => NavigatorUtils.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Colours.text),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 21.fit),
          const Text(
            '输入提现密码',
            style: TextStyles.textBold24,
          ),
          SizedBox(height: 8.fit),
          const Text(
            '输入旧密码完成身份验证',
            style: TextStyle(color: Colours.textGray),
          ),
          SizedBox(height: 48.fit),
          ShopPwdCodeView(
            margin: EdgeInsets.only(left: 16.fit, right: 16.fit),
            height: 40.fit,
            radius: 4.fit,
            pwd: inputPwd,
          ),
          Expanded(child: Container()),
          NumberKeyboard(
            onDelete: () {
              setState(() {
                if (inputPwd.isNotEmpty) {
                  inputPwd.removeLast();
                }
              });
            },
            onTapNumber: (number) {
              setState(() {
                if (inputPwd.length < 6) {
                  inputPwd.add(number);
                }

                if (inputPwd.length == 6) {
                  Toast.show('密码修改成功');
                  NavigatorUtils.pop(context);
                }
              });
            },
          )
        ],
      ),
    );
  }
}
