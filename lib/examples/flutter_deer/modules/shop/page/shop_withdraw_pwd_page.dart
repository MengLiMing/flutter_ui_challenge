import 'package:flutter/material.dart';
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
          ListClickItem(title: '修改密码', onTap: () {}),
          ListClickItem(title: '忘记密码', onTap: () {}),
        ],
      ),
    );
  }
}
