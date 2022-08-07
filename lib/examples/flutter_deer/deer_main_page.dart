import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';

class DeerMainPage extends ConsumerWidget {
  const DeerMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userInfo(),
            ElevatedButton(
              onPressed: () {
                NavigatorUtils.pushNeedLogin(context, CommonRouter.main);
              },
              child: const Text('需要登录的跳转'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(UserProviders.userInfo.notifier).logOut();
              },
              child: const Text('退出'),
            ),
          ],
        ),
      ),
    );
  }

  Widget userInfo() {
    return Consumer(builder: (context, ref, _) {
      final userinfo = ref.watch(UserProviders.userInfo);
      if (userinfo == null) {
        return const Text('未登录');
      } else {
        return Text('用户信息：${userinfo.name}');
      }
    });
  }
}
