import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/change_app_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/settings/widgets/setting_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/alert_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('设置'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SettingItem(title: '退出登录', onTap: logout),
            SettingItem(title: '切换App', onTap: exchangeApp),
            SettingItem(
                title: 'Github', content: 'follow & star', onTap: toGithub),
          ],
        ),
      ),
    );
  }

  void logout() => DialogUtils.show(context, builder: (context) {
        return AlertView(
          title: '提示',
          message: '您确定要退出登录吗？',
          onTap: () {
            ref.read(UserProviders.userInfo.notifier).logOut();
          },
        );
      });

  void exchangeApp() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const ChangeAppPage();
      }));

  void toGithub() => NavigatorUtils.pushToWeb(
      context, 'Github', 'https://www.github.com/MengLiMing');
}
